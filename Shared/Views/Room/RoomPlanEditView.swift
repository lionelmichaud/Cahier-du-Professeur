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

struct RoomPlanEditView: View {
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
                    ForEach($room.seats, id:\.self) { $seat in
                        DraggableSeatLabel(seatLocInRoom    : $seat.locInRoom,
                                           viewGeometrySize : viewGeometry.size,
                                           imageSize        : imageSize)
                    }
                }
            }
        }
    }
}

struct RoomPlan_Previews: PreviewProvider {
    static var room: Room = {
        var r = Room(name: "TECHNO-2", capacity: 12)
        r.seats.append(Seat(x: 0.0, y: 0.0))
        r.seats.append(Seat(x: 0.25, y: 0.25))
        r.seats.append(Seat(x: 0.5, y: 0.5))
        r.seats.append(Seat(x: 0.75, y: 0.75))
        r.seats.append(Seat(x: 0.98, y: 0.98))
        return r
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                RoomPlanEditView(room: .constant(room))
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomPlanEditView(room: .constant(room))
            }
            .previewDevice("iPhone 13")
        }
    }
}
