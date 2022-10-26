//
//  RoomPlan.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/10/2022.
//

import SwiftUI

struct RoomPlanView: View {
    @Binding
    var room: Room

    private var imageSize: CGSize? {
        room.imageSize
    }

    var body: some View {
        if let roomPlanURL = room.planURL,
        let imageSize {
            ZStack(alignment: .topLeading) {
                GeometryReader { geometry in
                    LoadableImage(imageUrl         : roomPlanURL,
                                  placeholderImage : .constant(Image(systemName : "questionmark.app.dashed")))
                    ForEach(room.places, id:\.self) { place in
                        Place(position: place, text: nil)
                            .offset(offset(relativePos  : place,
                                           geometrySize : geometry.size,
                                           imageSize    : imageSize))
                    }
                }
            }
        }
    }

    // MARK: - Methods

    private func offset(relativePos  : CGPoint,
                        geometrySize : CGSize,
                        imageSize    : CGSize) -> CGSize {
        CGSize(width  : relativePos.x * geometrySize.width,
               height : relativePos.y * imageSize.height * geometrySize.width / imageSize.width)
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
