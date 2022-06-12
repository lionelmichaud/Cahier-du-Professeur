//
//  ColleEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ColleEditor: View {
    var classe: Classe
    @Binding
    var eleve: Eleve
    @Binding
    var colle: Colle
    var filterColle : Bool
    var isNew = false

    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore : ColleStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Colle()
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false
    @State private var alertItem : AlertItem?

    private var isItemDeleted: Bool {
        !colleStore.isPresent(colle) && !isNew
    }

    /// True si l'item est filtré (masqué)
    private var isItemFiltred: Bool {
        !filteredSortedColle(dans: classe).contains {
            $0.wrappedValue.id == colle.id
        }
    }

    var body: some View {
        if (isNew || !isItemFiltred) {
            VStack {
                ColleDetail(eleve      : eleve,
                            colle      : $itemCopy,
                            isEditing  : isEditing,
                            isNew      : isNew,
                            isModified : $isModified)
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
                                // Ajouter une nouvelle colle à l'élève
                                withAnimation {
                                    EleveManager()
                                        .ajouter(colle      : &itemCopy,
                                                 aEleve     : &eleve,
                                                 colleStore : colleStore)
                                }
                                dismiss()
                            } else {
                                // Appliquer les modifications faites à la colle
                                if isEditing && !isDeleted {
                                    print("Done, saving any changes to \(colle.id).")
                                    withAnimation {
                                        colle = itemCopy // Put edits (if any) back in the store.
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
                    if (isNew || !isItemFiltred) {
                        itemCopy   = colle
                        isModified = false
                        isSaved    = false
                    }
                }
                .onDisappear {
                    if isModified && !isSaved {
                        // Appliquer les modifications faites à la colle hors du mode édition
                        colle = itemCopy
                        isModified = false
                        isSaved    = true
                    }
                }
                .disabled(isItemDeleted)
            }
            .overlay(alignment: .center) {
                if isItemDeleted {
                    Color(UIColor.systemBackground)
                    Text("Colle supprimée. Sélectionner une colle.")
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            Text("Aucune colle sélectionnée.")
        }
    }

    init(classe      : Classe,
         eleve       : Binding<Eleve>,
         colle       : Binding<Colle>,
         isNew       : Bool = false,
         filterColle : Bool) {
        self.classe      = classe
        self._eleve      = eleve
        self._colle      = colle
        self.isNew       = isNew
        self.filterColle = filterColle
        self._itemCopy   = State(initialValue : colle.wrappedValue)
    }

    // MARK: - Methods

    func filteredSortedColle(dans classe: Classe) -> Binding<[Colle]> {
        eleveStore.filteredSortedColles(dans        : classe,
                                        colleStore  : colleStore,
                                        isConsignee : filterColle ? false : nil)
    }
}

struct ColleEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ColleEditor(classe      : TestEnvir.classeStore.items.first!,
                        eleve       : .constant(TestEnvir.eleveStore.items.first!),
                        colle       : .constant(TestEnvir.colleStore.items.first!),
                        isNew       : true,
                        filterColle : false)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            ColleEditor(classe      : TestEnvir.classeStore.items.first!,
                        eleve       : .constant(TestEnvir.eleveStore.items.first!),
                        colle       : .constant(TestEnvir.colleStore.items.first!),
                        isNew       : true,
                        filterColle : false)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}
