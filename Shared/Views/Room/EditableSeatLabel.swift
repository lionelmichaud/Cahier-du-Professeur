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
    private var eleveStore : EleveStore

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    // MARK: - ComputedProperties

    private var unSeatedEleves: [Binding<Eleve>] {
        RoomManager.unSeatedEleves(dans: classe,
                                   eleveStore: eleveStore)
    }

    private var nameOfEleveOnSeat: String {
        RoomManager.eleveOnSeat(
            seatID: seat.id,
            dans: classe,
            eleveStore: eleveStore
        )?.displayName(nameDisplayOrder) ?? "Associer"
    }

    private var associateEleveToSeatMenu: some View {
        Menu {
            ForEach(unSeatedEleves, id:\.wrappedValue) { $eleve in
                Button(eleve.displayName(nameDisplayOrder)) {
                    withAnimation {
                        eleve.seatId = seat.id
                    }
                }
            }
        } label: {
            SeatLabel(label: nameOfEleveOnSeat)
        }
    }

    var body: some View {
        associateEleveToSeatMenu
        //SeatLabel(label: "Prénom")
            .offset(posInView(relativePos  : seat.locInRoom,
                              geometrySize : viewGeometrySize,
                              imageSize    : imageSize)
            )
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
