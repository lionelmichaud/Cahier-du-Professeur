//
//  RoomEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI

struct RoomElevePlacement: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var schoolStore : SchoolStore

    @State
    private var isShowingDissociateDialog = false

    // MARK: - ComputedProperties

    private var school: School? {
        guard let schoolId = classe.schoolId else {
            return nil
        }
        return schoolStore.item(withID: schoolId)
    }

    private var room: Room? {
        guard let school, let roomId = classe.roomId else {
            return nil
        }
        return RoomManager.room(withId: roomId, in: school)
    }

    private var roomName: String {
        room?.name ?? ""
    }

    private var imageSize: CGSize? {
        room?.imageSize
    }

    private var associateMenu: some View {
        Menu {
            ForEach(school!.rooms) { room in
                Button(room.name) {
                    withAnimation {
                        classe.roomId = room.id
                    }
                }
            }
        } label: {
            Label("Associer", systemImage: "plus.circle.fill")
        }
    }

    var body: some View {
        Group {
            if classe.hasAssociatedRoom {
                // TODO: - Gérer ici la mise à jour de la photo par drag and drop
                if let roomPlanURL = room?.planURL,
                   let imageSize {
                    ZStack(alignment: .topLeading) {
                        GeometryReader { viewGeometry in
                            LoadableImage(imageUrl: roomPlanURL,
                                          placeholderImage: .constant(Image(systemName: "questionmark.app.dashed")))

                            // Symboles des places des élèves dans la salle
                            ForEach(room!.seats, id:\.self) { seat in
                                SeatLabel(label: "Prénom")
                                    .offset(posInView(relativePos  : seat.locInRoom,
                                                      geometrySize : viewGeometry.size,
                                                      imageSize    : imageSize)
                                    )
                            }
                        }
                    }
                } else {
                    Text("Plan de salle introuvable")
                        .foregroundStyle(.secondary)
                        .font(.title)
                }
            } else {
                VStack {
                    Text("Aucune salle de classe")
                    Text("Définir une salle de classe")
                }
                .foregroundStyle(.secondary)
                .font(.title)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if classe.hasAssociatedRoom {
                    /// Dissocier la classe de la salle de classe
                    Button(role: .destructive) {
                        isShowingDissociateDialog.toggle()
                    } label: {
                        Label("Dissocier", systemImage: "minus.circle.fill")
                    }
                    .confirmationDialog("Dissocier la classe de cette salle de cours?",
                                        isPresented: $isShowingDissociateDialog) {
                        Button("Dissocier", role: .destructive) {
                            withAnimation {
                                classe.roomId = nil
                            }
                        }
                    } message: {
                        Text("Cette action ne peut pas être annulée.")
                    }
                } else if school != nil {
                    /// associer la classe à une salle de classe
                    associateMenu
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Salle \(roomName)")
        .navigationBarTitleDisplayMode(.inline)
        #endif
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

struct RoomEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                RoomElevePlacement(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomElevePlacement(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
