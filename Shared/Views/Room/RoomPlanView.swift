//
//  RoomPlan.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/10/2022.
//

import SwiftUI

public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

struct RoomPlanView: View {
    @Binding
    var room: Room

    // MARK: - Computd Properties

    private var imageSize: CGSize? {
        room.imageSize
    }

    var body: some View {
        if let roomPlanURL = room.planURL,
        let imageSize {
            ZStack(alignment: .topLeading) {
                GeometryReader { viewGeometry in
                    // Image du plan de la salle
                    LoadableImage(imageUrl         : roomPlanURL,
                                  placeholderImage : .constant(Image(systemName : "questionmark.app.dashed")))

                    // Symboles des places des élèves dans la salle
                    ForEach($room.places, id:\.self) { $place in
                        DraggablePlaceLabel(place            : $place,
                                            viewGeometrySize : viewGeometry.size,
                                            imageSize        : imageSize)
                    }
                }
            }
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

struct RoomPlan_Previews: PreviewProvider {
    static var room: Room = {
        var r = Room(name: "TECHNO-2", capacity: 12)
        r.places.append(CGPoint(x: 0.0, y: 0.0))
        r.places.append(CGPoint(x: 0.25, y: 0.25))
        r.places.append(CGPoint(x: 0.5, y: 0.5))
        r.places.append(CGPoint(x: 0.75, y: 0.75))
        r.places.append(CGPoint(x: 0.98, y: 0.98))
        return r
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                RoomPlanView(room: .constant(room))
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomPlanView(room: .constant(room))
            }
            .previewDevice("iPhone 13")
        }
    }
}
