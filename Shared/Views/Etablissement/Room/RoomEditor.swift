//
//  RoomPlacement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI
import os
import Files

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "RoomEditor")

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

    @State
    private var isShowingDeletePlanConfirmDialog: Bool = false

    // MARK: - Computed Properties

    private var title: String {
        if hClass == .regular {
            return "Places: positionnées \(room.nbSeatPositionned) - non positionnées: \(room.nbSeatUnpositionned)"
        } else {
            return "Places non positionnées: \(room.nbSeatUnpositionned)"
        }
    }

    var body: some View {
        RoomPlanEditView(room: $room, school: school)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                /// Positionner une nouvelle place au centre du plan de la salle de classe
                if room.nbSeatUnpositionned > 0 {
                    Button {
                        withAnimation {
                            room.addSeatToPlan(Seat(x: 0.5, y: 0.5))
                        }
                    } label: {
                        Label("Ajouter une place", systemImage: "chair")
                    }
                }
                /// Supprimer tous les positionnements de places dans la salle de classe
                if room.nbSeatPositionned > 0 {
                    Button(role: .destructive) {
                        withAnimation {
                            // Supprimer tous les sièges positionnés sur le plan de la salle de classe.
                            // Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
                            room.removeAllSeatsFromPlan(dans: school,
                                                        classStore: classStore,
                                                        eleveStore: eleveStore)
                        }
                    } label: {
                        Label("Tout effacer", systemImage: "trash.fill")
                    }
                }
                // TODO: - Ajouter un item pour changer le plan de la salle
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("OK") {
                        dismiss()
                    }
                }
                if room.planExists {
                    ToolbarItemGroup(placement: .automatic) {
                        Menu {
                            /// Suppression du plan de la salle de classe
                            Button(role: .destructive) {
                                isShowingDeletePlanConfirmDialog.toggle()
                            } label: {
                                Label("Supprimer le plan", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        /// Confirmation de Suppression de la salle de classe
                        .confirmationDialog("Suppression du plan",
                                            isPresented: $isShowingDeletePlanConfirmDialog,
                                            titleVisibility : .visible) {
                            Button("Supprimer", role: .destructive) {
                                withAnimation {
                                    // TODO: - A tester
                                    // Supprimer tous les sièges positionnés sur le plan de la salle de classe.
                                    // Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
                                    room.removeAllSeatsFromPlan(dans: school,
                                                                classStore: classStore,
                                                                eleveStore: eleveStore)

                                    // Supprimer l'image du plan de la salle de classe
                                    deletePlanFile(roomPlanURL: room.planURL)
                                }
                            }
                        } message: {
                            VStack {
                                Text("Cette action supprimera le plan de la salle de classe ainsi que toutes les places associées.\n") +
                                Text("Cette action ne supprimera pas la salle de classe elle-même.\n") +
                                Text("Cette action ne peut pas être annulée.")
                            }
                        }
                    }
                }
            }
    }

    // MARK: - Methods

    func deletePlanFile(roomPlanURL: URL) {
        try? PersistenceManager().deleteFile(withURL: roomPlanURL)
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
