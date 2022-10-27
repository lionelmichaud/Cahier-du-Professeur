//
//  DraggablePlaceLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 28/10/2022.
//

import SwiftUI

struct DraggablePlaceLabel: View {
    @Binding
    var place: CGPoint

    var viewGeometrySize : CGSize
    var imageSize        : CGSize

    @State
    private var translation = CGSize.zero

    var body: some View {
        PlaceLabel(text: nil)
            .offset(posInView(relativePos  : place,
                              geometrySize : viewGeometrySize,
                              imageSize    : imageSize) + translation
            )
            .gesture(DragGesture()
                .onChanged { value in
                    translation = value.translation
                }
                .onEnded { value in
                    translation = value.translation

                    let lastPositionInView =
                    posInView(relativePos  : place,
                              geometrySize : viewGeometrySize,
                              imageSize    : imageSize) + translation
                    place = relativePosInImage(
                        posInView    : lastPositionInView,
                        geometrySize : viewGeometrySize,
                        imageSize    : imageSize
                    )

                    translation = CGSize.zero
                }
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
        CGSize(width  : relativePos.x * geometrySize.width,
               height : relativePos.y * (geometrySize.width * imageSize.height / imageSize.width))
    }

    private func relativePosInImage(posInView    : CGSize,
                                    geometrySize : CGSize,
                                    imageSize    : CGSize) -> CGPoint {
        CGPoint(x: posInView.width / geometrySize.width,
                y: posInView.height / (geometrySize.width * imageSize.height / imageSize.width))
    }
}

//struct DraggablePlaceLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        DraggablePlaceLabel()
//    }
//}
