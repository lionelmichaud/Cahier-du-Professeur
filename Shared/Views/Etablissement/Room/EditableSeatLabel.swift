//
//  EditableSeatLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 29/10/2022.
//

import SwiftUI

struct EditableSeatLabel: View {
    var classe           : Classe
    var seat             : Seat
    var viewGeometrySize : CGSize
    var imageSize        : CGSize

    @EnvironmentObject
    private var navigationModel : NavigationModel

    @EnvironmentObject
    private var eleveStore : EleveStore

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @State
    private var isAddingNewObserv = false

    @State
    private var isAddingNewColle  = false

    // MARK: - ComputedProperties

    private var unSeatedEleves: [Binding<Eleve>] {
        RoomManager.unSeatedEleves(dans       : classe,
                                   eleveStore : eleveStore)
    }

    private var eleveOnSeat: Binding<Eleve>? {
        RoomManager.eleveOnSeat(
            seatID     : seat.id,
            dans       : classe,
            eleveStore : eleveStore
        )
    }

    private var nameOfEleveOnSeat: String {
        eleveOnSeat?
            .wrappedValue
            .name.givenName ?? "Associer"
    }

    /// Menu de placement d'un élève sur une place de la salle de classe
    private var seatMenu: some View {
        Group {
            if let eleveOnSeat {
                Section {
                    // aller à la fiche élève
                    Button {
                        // Programatic Navigation
                        navigationModel.selectedTab     = .eleve
                        navigationModel.selectedEleveId = eleveOnSeat.wrappedValue.id
                    } label: {
                        Label("Fiche élève", systemImage: "info.circle")
                    }
                    // ajouter un point de bonus
                    Button {
                        eleveOnSeat.wrappedValue.bonus += 1.0
                    } label: {
                        Label("Ajouter bonus", systemImage: "hand.thumbsup")
                    }
                    // ajouter un point de malus
                    Button {
                        eleveOnSeat.wrappedValue.bonus -= 1.0
                    } label: {
                        Label("Ajouter malus", systemImage: "hand.thumbsdown")
                    }

                    // ajouter une observation
                    Button {
                        isAddingNewObserv = true
                    } label: {
                        Label("Nouvelle observation", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                    // ajouter une colle
                    Button {
                        isAddingNewColle = true
                    } label: {
                        Label("Nouvelle colle", systemImage: "lock.fill")
                    }
                }

                Section {
                    // enlever l'élève qui était assis à cette place
                    Button(role: .destructive) {
                        withAnimation {
                            // enlever l'élève qui était assis à cette place
                            eleveOnSeat.wrappedValue.seatId = nil
                        }
                    } label: {
                        Label("Libérer la place", systemImage: "chair")
                    }
                }
            }

            Section {
                ForEach(unSeatedEleves, id:\.wrappedValue) { $eleve in
                    Button(eleve.displayName(nameDisplayOrder)) {
                        withAnimation {
                            // enlever l'élève qui était assis à cette place
                            eleveOnSeat?.wrappedValue.seatId = nil
                            // pour y mettre cet élève là
                            eleve.seatId = seat.id
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        SeatLabel(label          : nameOfEleveOnSeat,
                  backgoundColor : eleveOnSeat == nil ? .pink  : .blue)
        .contextMenu {
            seatMenu
        } preview: {
            if eleveOnSeat != nil,
               let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleveOnSeat!.wrappedValue) {
                LoadableImage(imageUrl         : trombine,
                              placeholderImage : .constant(Image(systemName: "person.fill.questionmark")))
            } else {
                Image(systemName: "questionmark.app.dashed")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 75, minHeight: 75)
            }
        }
        .offset(posInView(relativePos  : seat.locInRoom,
                          geometrySize : viewGeometrySize,
                          imageSize    : imageSize)
        )
        .sheet(isPresented: $isAddingNewObserv) {
            NavigationStack {
                ObservCreator(eleve: eleveOnSeat!)
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isAddingNewColle) {
            NavigationStack {
                ColleCreator(eleve: eleveOnSeat!)
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Methods

    /// Convertit la position de l'objet situé à une position relative (%) `relativePos` à l'intérieur de l'image de taille `imageSize`
    /// dans une position absolue en pixels dans la vue définie par `geometrySize`.
    /// - Parameters:
    ///   - relativePos: position relative (%) de l'objet dans l'image de taille `imageSize`
    ///   - geometrySize: taille de la vue contenant l'image (alignée .topLeading)
    ///   - imageSize: taille de l'image dans laquelle se situe l'objet
    /// - Returns: position absolue en pixels de l'objet dans la vue définie par `geometrySize`
    private func posInView(relativePos  : CGPoint,
                           geometrySize : CGSize,
                           imageSize    : CGSize) -> CGSize {
        let imageSizeRatio    = imageSize.width / imageSize.height
        let geometrySizeRatio = geometrySize.width / geometrySize.height

        if imageSizeRatio >= geometrySizeRatio {
            return CGSize(width  : relativePos.x * geometrySize.width,
                          height : relativePos.y * (geometrySize.width * imageSize.height / imageSize.width))
        } else {
            return CGSize(width  : relativePos.x * (geometrySize.height * imageSize.width / imageSize.height),
                          height : relativePos.y * geometrySize.height)
        }
    }
}

//struct EditablePlaceLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        EditableSeatLabel()
//    }
//}
