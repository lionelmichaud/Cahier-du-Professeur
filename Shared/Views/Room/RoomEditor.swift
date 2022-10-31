//
//  RoomPlacement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI

struct RoomEditor: View {
    @Binding
    var room: Room

    var school: School

    @EnvironmentObject
    private var classStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.horizontalSizeClass)
    private var hClass

    // MARK: - Computed Properties

    private var title: String {
        if hClass == .regular {
            return "Places  - positionnées \(room.nbSeatPositionned) - non positionnées: \(room.nbSeatUnpositionned)"
        } else {
            return "Places non positionnées: \(room.nbSeatUnpositionned)"
        }
    }

    var body: some View {
        if room.planURL != nil {
            RoomPlanEditView(room: $room, school: school)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                /// positionner une nouvelle place au centre du plan de la salle de classe
                if room.nbSeatUnpositionned > 0 {
                    Button {
                        withAnimation {
                            room.addSeatToPlan(Seat(x: 0.5, y: 0.5))
                        }
                    } label: {
                        Label("Positionner nouvelle place", systemImage: "chair")
                    }
                }
                /// supprimer tous les positionnements de places dans la salle de classe
                if room.nbSeatPositionned > 0 {
                    Button(role: .destructive) {
                        withAnimation {
                            room.removeAllSeatsFromPlan(dans       : school,
                                                        classStore : classStore,
                                                        eleveStore : eleveStore)
                        }
                    } label: {
                        Label("Tout effacer", systemImage: "trash.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        } else {
            Text("Plan de salle introuvable")
                .foregroundStyle(.secondary)
                .font(.title)
        }
    }
}

struct RoomPlacement_Previews: PreviewProvider {
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
                RoomEditor(room: .constant(room),
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
                RoomEditor(room: .constant(Room(name: "TECHNO-2",
                                                capacity: 12)),
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
