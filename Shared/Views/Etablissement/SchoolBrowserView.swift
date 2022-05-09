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
    @State private var isShowingDialog = false

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

                // menu
                ToolbarItemGroup(placement: .automatic) {
                    Menu {
                        // Exporter les fichiers JSON utilisateurs
                        Button(action: { share(geometry: geometry) }) {
                            Label("Exporter les données", systemImage: "square.and.arrow.up")
                        }
                        // Importer les fichiers JSON depuis le Bundle Application
                        Button(action: { isShowingDialog.toggle() }) {
                            Label("Importer les données", systemImage: "square.and.arrow.down")
                        }
                        Button(action: { isEditingPreferences = true }) {
                            Label("Préférences", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
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
        /// Importer les fichiers JSON depuis le Bundle Application
        .confirmationDialog(
            "L'importation va remplacer vos données actuelles par celles contenues dans l'Application.",
            isPresented: $isShowingDialog
        ) {
            Button("Importer", role: .destructive) {
                self.import()
            }
        } message: {
            Text("L'importation va remplacer vos données actuelles par celles contenues dans l'Application.\nCette action ne peut pas être annulée.")
            Text("Cette action ne peut pas être annulée.")
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
    func `import`() {
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
