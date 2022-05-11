//
//  SchoolBrowserView.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import Files
import FileAndFolder
import HelpersView

struct SchoolBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore
    @State
    private var isAddingNewEtab = false
    @State
    private var isEditingPreferences = false
    @State
    private var newEtab = School()
    @State
    private var alertItem: AlertItem?
    @State private var isShowingImportConfirmDialog = false
    @State private var isShowingDeleteConfirmDialog = false

    var body: some View {
        GeometryReader { geometry in
            List {
                if schoolStore.items.isEmpty {
                    Text("Aucun établissement")
                }
                ForEach(NiveauSchool.allCases) { niveau in
                    if !schoolStore.sortedSchools(niveau: niveau).isEmpty {
                        Section {
                            ForEach(schoolStore.sortedSchools(niveau: niveau)) { $school in
                                NavigationLink {
                                    SchoolEditor(school: $school)
                                } label: {
                                    SchoolBrowserRow(school: school)
                                }
                                .swipeActions {
                                    // supprimer un établissement
                                    Button(role: .destructive) {
                                        withAnimation {
                                            schoolStore.deleteSchool(school,
                                                                     classeStore : classeStore,
                                                                     eleveStore  : eleveStore,
                                                                     observStore : observStore,
                                                                     colleStore  : colleStore)
                                        }
                                    } label: {
                                        Label("Supprimer", systemImage: "trash")
                                    }
                                }
                            }
                        } header: {
                            Text(niveau.displayString)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                        }
                    }
                }
                #if targetEnvironment(simulator)
                Button {
                    TestEnvir.populateWithFakes(
                        schoolStore : schoolStore,
                        classeStore : classeStore,
                        eleveStore  : eleveStore,
                        observStore : observStore,
                        colleStore  : colleStore)
                } label: {
                    Text("Test").foregroundColor(.primary)
                }
                #endif
            }
            //.listStyle(.sidebar)
            .navigationTitle("Etablissements")
            //.navigationViewStyle(.columns)
            .toolbar {
                // ajouter un établissement
                ToolbarItemGroup(placement: .status) {
                    Button {
                        newEtab = School()
                        isAddingNewEtab = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Ajouter un établissement")
                            Spacer()
                        }
                    }
                }

                /// Menu
                ToolbarItemGroup(placement: .automatic) {
                    Menu {
                        /// Edition des préférences utilisateur
                        Button(action: { isEditingPreferences = true }) {
                            Label("Préférences", systemImage: "gear")
                        }

                        /// Exporter les fichiers JSON utilisateurs
                        Button(action: { share(geometry: geometry) }) {
                            Label("Exporter vos données", systemImage: "square.and.arrow.up")
                        }

                        /// Importer les fichiers JSON depuis le Bundle Application
                        Button(role: .destructive, action: { isShowingImportConfirmDialog.toggle() }) {
                            Label("Importer les données de l'App", systemImage: "square.and.arrow.down")
                        }

                        /// Effacer toutes les données utilisateur
                        Button(role: .destructive, action: { isShowingDeleteConfirmDialog.toggle() }) {
                            Label("supprimer toutes vos données", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .confirmationDialog("Importation des fichiers de l'App",
                                isPresented: $isShowingImportConfirmDialog,
                                titleVisibility : .visible) {
                Button("Importer", role: .destructive) {
                    withAnimation {
                        self.import()
                    }
                }
            } message: {
                Text("L'importation va remplacer vos données actuelles par celles contenues dans l'Application.") +
                Text("Cette action ne peut pas être annulée.")
            }

            .confirmationDialog("Suppression de toutes vos données",
                                isPresented: $isShowingDeleteConfirmDialog,
                                titleVisibility : .visible) {
                Button("Supprimer", role: .destructive) {
                    withAnimation {
                        self.clearAllUserData()
                    }
                }
            } message: {
                Text("Cette action ne peut pas être annulée.")
            }

            .sheet(isPresented: $isAddingNewEtab) {
                NavigationView {
                    SchoolEditor(school: $newEtab, isNew: true)
                }
            }

            .sheet(isPresented: $isEditingPreferences) {
                NavigationView {
                    EmptyView()
                }
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }

    /// Exporter tous les fichiers JSON utilisateur
    private func share(geometry: GeometryProxy) {
        shareFiles(fileNames: [".json"],
                   alertItem: &alertItem,
                   geometry: geometry)
    }

    /// Importer les fichiers JSON depuis le Bundle Application
    private func `import`() {
        do {
            try PersistenceManager().forcedImportAllJsonFilesFromApp()
        } catch {
            /// trigger second alert
            DispatchQueue.main.async {
                self.alertItem = AlertItem(title: Text("Erreur"),
                                           message: Text("L'importation des fichiers a échouée!"),
                                           dismissButton: .default(Text("OK")))
            }
        }
        do {
            try schoolStore.loadFromJSON(fromFolder: nil)
            try classeStore.loadFromJSON(fromFolder: nil)
            try eleveStore.loadFromJSON(fromFolder: nil)
            try colleStore.loadFromJSON(fromFolder: nil)
            try observStore.loadFromJSON(fromFolder: nil)
        } catch {
            /// trigger second alert
            DispatchQueue.main.async {
                self.alertItem = AlertItem(title: Text("Erreur"),
                                           message: Text("La lecture des fichiers importés a échouée!"),
                                           dismissButton: .default(Text("OK")))
            }
        }
        eleveStore.sort()
    }

    /// Suppression de toutes les données utilisateur
    private func clearAllUserData() {
        schoolStore.clear()
        classeStore.clear()
        eleveStore.clear()
        colleStore.clear()
        observStore.clear()

    }
}

struct SchoolBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            SchoolBrowserView()
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
