//
//  ClasseEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import Files
import HelpersView

struct ClasseEditor: View {
    //@Binding
    var school: School

    @Binding
    var classe: Classe

    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore

    @State
    private var alertItem : AlertItem?
    @State
    private var isShowingImportListeDialog = false
    @State
    private var importCsvFile = false

    private var isItemDeleted: Bool {
        !classeStore.contains(classe)
    }

    @Preference(\.interoperability)
    var interoperability

    var body: some View {
        ClasseDetail(classe: $classe)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    /// Importation des données
                    /// Importer une liste d'élèves d'une classe depuis un fichier CSV au format PRONOTE
                    Button {
                        isShowingImportListeDialog.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .imageScale(.large)
                    }
                    /// Confirmation de l'importation d'une liste d'élèves d'une classe
                    .confirmationDialog("Importer une liste d'élèves",
                                        isPresented     : $isShowingImportListeDialog,
                                        titleVisibility : .visible) {
                        Button("Importer et ajouter") {
                            withAnimation {
                                importCsvFile = true
                            }
                        }
                        Button("Importer et remplacer", role: .destructive) {
                            withAnimation {
                                ClasseManager().retirerTousLesEleves(deClasse    : &classe,
                                                                     eleveStore  : eleveStore,
                                                                     observStore : observStore,
                                                                     colleStore  : colleStore)
                            }
                            importCsvFile = true
                        }
                    } message: {
                        Text("La liste des élèves importée doit être au format CSV de \(interoperability == .proNote ? "PRONOTE" : "EcoleDirecte").") +
                        Text("Cette action ne peut pas être annulée.")
                    }
                }
            }
            .disabled(isItemDeleted)
            .overlay(alignment: .center) {
                if isItemDeleted {
                    Color(UIColor.systemBackground)
                    Text("Classe supprimée. Sélectionner une classe.")
                        .foregroundStyle(.secondary)
                }
            }
            .alert(item: $alertItem, content: newAlert)
            /// Importer un fichier CSV au format PRONOTE ou EcoleDirecte
            .fileImporter(isPresented             : $importCsvFile,
                          allowedContentTypes     : [.commaSeparatedText],
                          allowsMultipleSelection : false) { result in
                importCsvFiles(result: result)
            }
    }

    // MARK: - Methods
    
    private func importCsvFiles(result: Result<[URL], Error>) {
        switch result {
            case .failure(let error):
                self.alertItem = AlertItem(title         : Text("Échec"),
                                           message       : Text("L'importation du fichier a échouée"),
                                           dismissButton : .default(Text("OK")))
                print("Error selecting file: \(error.localizedDescription)")

            case .success(let filesUrl):
                filesUrl.forEach { fileUrl in
                    guard fileUrl.startAccessingSecurityScopedResource() else { return }

                    if let data = try? Data(contentsOf: fileUrl) {
                        do {
                            var eleves = [Eleve]()

                            switch interoperability {
                                case .ecoleDirecte:
                                    eleves = try CsvImporter().importElevesFromEcoleDirecte(from: data)

                                case .proNote:
                                    eleves = try CsvImporter().importElevesFromPRONOTE(from: data)
                            }

                            for idx in eleves.startIndex...eleves.endIndex-1 {
                                withAnimation {
                                    ClasseManager()
                                        .ajouter(eleve      : &eleves[idx],
                                                 aClasse    : &classe,
                                                 eleveStore : eleveStore)
                                }
                            }
                        } catch let error {
                            self.alertItem = AlertItem(title         : Text("Échec"),
                                                       message       : Text("L'importation du fichier a échouée"),
                                                       dismissButton : .default(Text("OK")))
                            print("Error reading file \(error.localizedDescription)")
                        }
                    }

                    fileUrl.stopAccessingSecurityScopedResource()
                }
        }
    }
}

struct ClasseEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                ClasseEditor(school : TestEnvir.schoolStore.items.first!,
                             classe : .constant(TestEnvir.classeStore.items.first!))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationView {
                ClasseEditor(school : TestEnvir.schoolStore.items.first!,
                             classe : .constant(TestEnvir.classeStore.items.first!))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
