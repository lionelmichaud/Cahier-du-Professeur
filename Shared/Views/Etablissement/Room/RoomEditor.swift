//
//  RoomPlacement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI
import os
import Files
import HelpersView

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "RoomEditor")

struct RoomEditor: View {
    @Binding
    var room: Room

    var school: School

    @EnvironmentObject
    private var classeStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.horizontalSizeClass)
    private var hClass

    @State
    private var isShowingDeletePlanConfirmDialog: Bool = false

    @State
    private var isShowingChangePlanConfirmDialog: Bool = false

    @State
    private var isImportingPngFile = false

    @State
    private var alertItem: AlertItem?

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
                            // Supprime le plan de salle de classe `room` de l'établissement `school`..
                            // Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
                            room.removeAllSeatsFromPlan(dans: school,
                                                        classStore: classeStore,
                                                        eleveStore: eleveStore)
                        }
                    } label: {
                        Label("Effacer toutes les places", systemImage: "trash.fill")
                    }
                }
            }
            .alert(item: $alertItem, content: newAlert)
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
                            /// Suppression du plan de la salle de classe
                            Button(role: .destructive) {
                                isShowingChangePlanConfirmDialog.toggle()
                            } label: {
                                Text("Changer de plan")
                            }

                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        /// Confirmation de Suppression du plan de la salle de classe
                        .confirmationDialog("Suppression du plan",
                                            isPresented: $isShowingDeletePlanConfirmDialog,
                                            titleVisibility : .visible) {
                            Button("Supprimer", role: .destructive) {
                                withAnimation {
                                    RoomManager.deleteRoomPlan(
                                        de: &room,
                                        dans: school,
                                        classeStore: classeStore,
                                        eleveStore: eleveStore
                                    )
                                }
                            }
                        } message: {
                            Text("Cette action supprimera le plan de la salle de classe ainsi que toutes les places associées.\n") +
                            Text("Cette action ne supprimera pas la salle de classe elle-même.\n") +
                            Text("Cette action ne peut pas être annulée.")
                        }
                        // TODO: - A tester
                        /// Confirmation de changement du plan de la salle de classe
                        .confirmationDialog("Changement du plan",
                                            isPresented: $isShowingChangePlanConfirmDialog,
                                            titleVisibility : .visible) {
                            Button("Changer", role: .destructive) {
                                isImportingPngFile.toggle()
                            }
                        } message: {
                            Text("Cette action supprimera le plan actuel de la salle de classe ainsi que toutes les places associées.\n") +
                            Text("Cette action ne supprimera pas la salle de classe elle-même.\n") +
                            Text("Cette action ne peut pas être annulée.")
                        }
                        /// Importer un fichier PNG
                        .fileImporter(isPresented             : $isImportingPngFile,
                                      allowedContentTypes     : [.png],
                                      allowsMultipleSelection : false) { result in
                            withAnimation {
                                // supprimer le plan existant
                                switch result {
                                    case .success:
                                        RoomManager.deleteRoomPlan(
                                            de: &room,
                                            dans: school,
                                            classeStore: classeStore,
                                            eleveStore: eleveStore
                                        )
                                    case .failure:
                                        break
                                }
                                // pour le remplacer par un autre
                                importUserSelectedFiles(result: result)
                            }
                        }
                    }
                }
            }
    }

    // MARK: - Methods

    /// Copier les fichiers  sélectionnés dans le dossier Document de l'application.
    /// Ajouter un document à l'établissement pour chaque fichier importé.
    /// - Parameter result: résultat de la sélection des fichiers issue de fileImporter.
    private func importUserSelectedFiles(result: Result<[URL], Error>) {
        switch result {
            case .failure(let error):
                self.alertItem = AlertItem(title         : Text("Échec"),
                                           message       : Text("L'importation du fichier a échouée"),
                                           dismissButton : .default(Text("OK")))
                customLog.log(level: .fault,
                              "Error selecting file: \(error.localizedDescription)")

            case .success(let filesUrl):
                if let theFileURL = filesUrl.first {
                    // Si le fichier ne porte le bon nom, arrêter l'importation
                    guard theFileURL.pathComponents.last == room.fileName else {
                        self.alertItem = AlertItem(title         : Text("Échec"),
                                                   message       : Text("Le nom du fichier importé ne correspond pas au nom de la salle de classe."),
                                                   dismissButton : .default(Text("OK")))
                        return
                    }

                    do {
                        try ImportExportManager
                            .importURLsToDocumentsFolder(filesUrl             : [theFileURL],
                                                         importIfAlreadyExist : true)

                    } catch {
                        self.alertItem = AlertItem(title         : Text("Échec"),
                                                   message       : Text("L'importation du fichier a échouée"),
                                                   dismissButton : .default(Text("OK")))
                    }
                }
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
