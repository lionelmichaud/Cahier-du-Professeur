//
//  ColleEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ColleEditor: View {
    @Binding
    var eleve: Eleve
    @Binding
    var colle: Colle
    var isNew = false

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

    var body: some View {
        ColleDetail(colle      : $itemCopy,
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
                        // Ajouter un nouvel élève à la classe
                        withAnimation {
                            EleveManager()
                                .ajouter(colle      : &itemCopy,
                                         aEleve     : &eleve,
                                         colleStore : colleStore)
                        }
                        dismiss()
                    } else {
                        // Appliquer les modifications faites à l'colleation
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
        .onDisappear {
            if isModified && !isSaved {
                // Appliquer les modifications faites à la classe hors du mode édition
                colle = itemCopy
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }

    init(eleve  : Binding<Eleve>,
         colle : Binding<Colle>,
         isNew  : Bool = false) {
        self.isNew     = isNew
        self._eleve    = eleve
        self._colle   = colle
        self._itemCopy = State(initialValue : colle.wrappedValue)
    }
}

struct ColleEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                ColleEditor(eleve: .constant(TestEnvir.eleveStore.items.first!),
                            colle: .constant(TestEnvir.colleStore.items.first!),
                            isNew: true)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationView {
                EmptyView()
                ColleEditor(eleve: .constant(TestEnvir.eleveStore.items.first!),
                            colle: .constant(TestEnvir.colleStore.items.first!),
                            isNew: true)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 11")
        }
    }
}
