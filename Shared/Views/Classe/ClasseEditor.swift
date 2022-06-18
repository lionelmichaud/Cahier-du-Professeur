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
    @Binding
    var school: School
    @Binding
    var classe: Classe
    var isNew = false

    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var hClass

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Classe(niveau: .n6ieme, numero: 1)
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifictions sont faites hors du mode édition
    @State private var isModified = false
    @State private var examIsModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false
    @State private var alertItem : AlertItem?
    @State private var isShowingImportListeDialog = false
    @State private var importCsvFile = false

    private var isItemDeleted: Bool {
        !classeStore.isPresent(classe) && !isNew
    }

    var body: some View {
        VStack {
            ClasseDetail(classe         : $itemCopy,
                         isEditing      : isEditing,
                         isNew          : isNew,
                         isModified     : $isModified,
                         examIsModified : $examIsModified)
            .onChange(of: examIsModified, perform: { hasBeenModified in
                //                print("examIsModified modifié dans ClasseEditor: \(hasBeenModified)")
                if hasBeenModified && !isSaved {
                    // Appliquer les modifications faites à la classe hors du mode édition
                    // avant que .onAppear ne reset la valeur de isModified à False
                    classe         = itemCopy
                    examIsModified = false
                    isSaved        = true
                }
            })
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if isNew {
                        Button("Annuler") {
                            dismiss()
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        if isNew {
                            addNewItem()
                        } else {
                            /// Appliquer les modifications faites à la classe
                            if isEditing && !isDeleted {
                                print("Done, saving any changes to \(classe.displayString).")
                                withAnimation {
                                    classe = itemCopy // Put edits (if any) back in the store.
                                }
                                isSaved = true
                            }
                            isEditing.toggle()
                        }
                    } label: {
                        Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                    }

                    /// Importation des données
                    if !isNew && !isEditing {
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
                                withAnimation() {
                                    importCsvFile = true
                                }
                            }
                            Button("Importer et remplacer", role: .destructive) {
                                withAnimation() {
                                    ClasseManager().retirerTousLesEleves(deClasse    : &classe,
                                                                         eleveStore  : eleveStore,
                                                                         observStore : observStore,
                                                                         colleStore  : colleStore)
                                }
                                importCsvFile = true
                            }
                        } message: {
                            Text("La liste des élèves importée doit être au format CSV de PRONOTE.") +
                            Text(" Cette action ne peut pas être annulée.")
                        }
                    }
                }
            }
            .onAppear {
                itemCopy   = classe
                isModified = false
                isSaved    = false
            }
            .onDisappear {
                if (isModified || examIsModified) && !isSaved {
                    // Appliquer les modifications faites à la classe hors du mode édition
                    classe         = itemCopy
                    isModified     = false
                    examIsModified = false
                    isSaved        = true
                }
            }
            .disabled(isItemDeleted)
            /// Importer un fichier CSV au format PRONOTE
            .fileImporter(isPresented             : $importCsvFile,
                          allowedContentTypes     : [.commaSeparatedText],
                          allowsMultipleSelection : false) { result in
                importCsvFiles(result: result)
            }
        }
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Classe supprimée. Sélectionner une classe.")
                    .foregroundStyle(.secondary)
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }

    // MARK: - Initializer

    init(school: Binding<School>,
         classe: Binding<Classe>,
         isNew : Bool = false) {
        self.isNew     = isNew
        self._school   = school
        self._classe   = classe
        self._itemCopy = State(initialValue : classe.wrappedValue)
    }

    // MARK: - Methods
    
    private func addNewItem() {
        /// Ajouter une nouvelle classe
        if classeStore.exists(classe: itemCopy, in: school.id) {
            self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                       message       : Text("Cette classe existe déjà dans cet établissement"),
                                       dismissButton : .default(Text("OK")))
        } else {
            withAnimation {
                SchoolManager()
                    .ajouter(classe      : &itemCopy,
                             aSchool     : &school,
                             classeStore : classeStore)
            }
            dismiss()
        }
    }

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
                            var eleves = try CsvImporter().importEleves(from: data)
                            for idx in eleves.startIndex...eleves.endIndex-1 {
                                withAnimation() {
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
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationView {
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")

            NavigationView {
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : false)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
