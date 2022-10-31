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

    var school: School

    @EnvironmentObject
    private var classStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

    @State
    private var showLongPressMenu = false

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
                    if room.nbSeatPositionned > 0 {
                        ForEach(0 ... (room.nbSeatPositionned - 1), id:\.self) { idxSeat in
                            DraggableSeatLabel(
                                seatLocInRoom    : $room[seatIndex: idxSeat].locInRoom,
                                viewGeometrySize : viewGeometry.size,
                                imageSize        : imageSize,
                                delete: {
                                    withAnimation {
                                        room.removeSeatFromPlan(seatIndex  : idxSeat,
                                                                dans       : school,
                                                                classStore : classStore,
                                                                eleveStore : eleveStore)
                                    }
                                }
                            )
                        }
                    }
                }
            }
        } else {
            Text("Pas de plan disponible pour la salle \(room.name)")
                .padding()
        }
    }
}

struct RoomPlan_Previews: PreviewProvider {
    static var room: Room = {
        var r = Room(name: "TECHNO-2", capacity: 12)
        r.addSeatToPlan(Seat(x: 0.0, y: 0.0))
        r.addSeatToPlan(Seat(x: 0.25, y: 0.25))
        r.addSeatToPlan(Seat(x: 0.5, y: 0.5))
        r.addSeatToPlan(Seat(x: 0.75, y: 0.75))
        r.addSeatToPlan(Seat(x: 0.98, y: 0.98))
        return r
    }()
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                RoomPlanEditView(room  : .constant(room),
                                 school: TestEnvir.schoolStore.items.first!)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomPlanEditView(room  : .constant(room),
                                 school: TestEnvir.schoolStore.items.first!)
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