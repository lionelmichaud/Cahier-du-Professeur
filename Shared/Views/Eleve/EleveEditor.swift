//
//  EleveEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI
import HelpersView

struct EleveEditor: View {
    @Binding
    var classe: Classe
    @Binding
    var eleve: Eleve
    var isNew             : Bool
    var filterObservation : Bool
    var filterColle       : Bool
    let searchString      : String

    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Eleve(sexe   : .male,
                                          nom    : "",
                                          prenom : "")
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false
    @State private var alertItem : AlertItem?

    /// True si l'élève n'est pas dans le store ET si on est pas en train d'ajouter un nouvel élève
    private var isItemDeleted: Bool {
        !eleveStore.contains(eleve) && !isNew
    }

    /// True si l'élève n'est pas dans la liste des élève de la `classe` satisfaisant aux critères de filtrage
    private var isItemFiltred: Bool {
        !filteredEleves(dans: classe).contains {
            $0.id == eleve.id
        }
    }
    
    var body: some View {
        if isNew || !isItemFiltred {
            VStack {
                EleveDetail(classe            : classe,
                            eleve             : $itemCopy,
                            isEditing         : isEditing,
                            isNew             : isNew,
                            filterObservation : filterObservation,
                            filterColle       : filterColle,
                            isModified        : $isModified)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if isNew {
                            Button("Annuler") {
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem {
                        Button {
                            if isNew {
                                // supprimer les caracctères blancs au début et à la fin
                                if itemCopy.name.familyName != nil {
                                    itemCopy.name.familyName!.trim()
                                    itemCopy.name.familyName = itemCopy.name.familyName!.uppercased()
                                }
                                if itemCopy.name.givenName != nil {
                                    itemCopy.name.givenName!.trim()
                                }
                                //trim(formName: itemCopy.name)
                                // Ajouter un nouvel élève à la classe
                                if eleveStore.exists(eleve: itemCopy, in: classe.id) {
                                    self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                               message       : Text("Cet élève existe déjà dans cette classe"),
                                                               dismissButton : .default(Text("OK")))
                                } else {
                                    withAnimation {
                                        ClasseManager()
                                            .ajouter(eleve      : &itemCopy,
                                                     aClasse    : &classe,
                                                     eleveStore : eleveStore)
                                    }
                                    dismiss()
                                }
                            } else {
                                // Appliquer les modifications faites à l'élève
                                if isEditing && !isDeleted {
                                    // supprimer les caracctères blancs au début et à la fin
                                    if itemCopy.name.familyName != nil {
                                        itemCopy.name.familyName!.trim()
                                        itemCopy.name.familyName = itemCopy.name.familyName!.uppercased()
                                    }
                                    if itemCopy.name.givenName != nil {
                                        itemCopy.name.givenName!.trim()
                                    }
                                    print("Done, saving any changes to \(eleve.displayName).")
                                    withAnimation {
                                        eleve = itemCopy // Put edits (if any) back in the store.
                                    }
                                    isSaved = true
                                }
                                isEditing.toggle()
                            }
                        } label: {
                            Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                        }
                    }
                }
                .onAppear {
                    if isNew || !isItemFiltred {
                        itemCopy   = eleve
                        isModified = false
                        isSaved    = false
                    }
                }
                .onDisappear {
                    if isModified && !isSaved {
                        // Appliquer les modifications faites à la classe hors du mode édition
                        eleve      = itemCopy
                        isModified = false
                        isSaved    = true
                    }
                }
                .disabled(isItemDeleted)
            }
            .overlay(alignment: .center) {
                if isItemDeleted {
                    Color(UIColor.systemBackground)
                    Text("Elève supprimé. Sélectionner un élève.")
                        .foregroundStyle(.secondary)
                }
            }
            .alert(item: $alertItem, content: newAlert)
        } else {
            Text("Aucun élève sélectionné.")
        }
    }

    // MARK: - Initializer

    init(classe            : Binding<Classe>,
         eleve             : Binding<Eleve>,
         isNew             : Bool   = false,
         filterObservation : Bool   = false,
         filterColle       : Bool   = false,
         searchString      : String = "") {
        self.isNew             = isNew
        self._classe           = classe
        self._eleve            = eleve
        self.filterObservation = filterObservation
        self.filterColle       = filterColle
        self.searchString      = searchString
        self._itemCopy         = State(initialValue : eleve.wrappedValue)
    }

    // MARK: - Methods

    /// Liste des élève de la `classe` satisfaisant aux critères de filtrage
    func filteredEleves(dans classe: Classe) -> Binding<[Eleve]> {
        EleveManager().filteredEleves(dans              : classe,
                                      eleveStore        : eleveStore,
                                      observStore       : observStore,
                                      colleStore        : colleStore,
                                      filterObservation : filterObservation,
                                      filterColle       : filterColle,
                                      filterFlag        : false,
                                      searchString      : searchString)
    }
}

struct EleveEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            EleveEditor(classe: .constant(TestEnvir.classeStore.items.first!),
                        eleve: .constant(TestEnvir.eleveStore.items.first!),
                        isNew  : true)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            EleveEditor(classe: .constant(TestEnvir.classeStore.items.first!),
                        eleve: .constant(TestEnvir.eleveStore.items.first!),
                        isNew  : true)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}
