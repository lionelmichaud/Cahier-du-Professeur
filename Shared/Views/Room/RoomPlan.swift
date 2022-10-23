//
//  RoomPlan.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/10/2022.
//

import SwiftUI

struct RoomPlan: View {
    @Binding
    var room: Room

    private func offset(pos: CGPoint, in size: CGSize) -> CGSize {
        CGSize(width  : pos.x * size.width,
               height : pos.y * size.height)
    }

    var body: some View {
        if let roomPlanURL = room.planURL {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    GeometryReader { geoPlan in
                        LoadableImage(imageUrl         : roomPlanURL,
                                      placeholderImage : .constant(Image(systemName : "questionmark.app.dashed")))
                        ForEach(room.places, id:\.self) { place in
                            Place(position: place, text: nil)
                                .offset(offset(pos: place, in: geoPlan.size))
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.width)
            }
        }
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
                RoomPlan(room: .constant(room))
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomPlan(room: .constant(room))
            }
            .previewDevice("iPhone 13")
        }
    }
}
