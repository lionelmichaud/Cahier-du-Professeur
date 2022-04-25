//
//  ObservEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ObservEditor: View {
    @Binding
    var eleve: Eleve
    @Binding
    var observ: Observation
    var isNew = false

    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Observation()
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false

    private var isItemDeleted: Bool {
        !observStore.isPresent(observ) && !isNew
    }

    var body: some View {
        VStack {
            ObservDetail(observ     : $itemCopy,
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
                                    .ajouter(observation : &itemCopy,
                                             aEleve      : &eleve,
                                             observStore : observStore)
                            }
                            dismiss()
                        } else {
                            // Appliquer les modifications faites à l'observation
                            if isEditing && !isDeleted {
                                print("Done, saving any changes to \(observ.id).")
                                withAnimation {
                                    observ = itemCopy // Put edits (if any) back in the store.
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
                itemCopy   = observ
                isModified = false
                isSaved    = false
            }
            .onDisappear {
                if isModified && !isSaved {
                    // Appliquer les modifications faites à la classe hors du mode édition
                    observ     = itemCopy
                    isModified = false
                    isSaved    = true
                }
            }
            .disabled(isItemDeleted)
        }
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Observation supprimée. Sélectionner une observation.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    init(eleve  : Binding<Eleve>,
         observ : Binding<Observation>,
         isNew  : Bool = false) {
        self.isNew     = isNew
        self._eleve    = eleve
        self._observ   = observ
        self._itemCopy = State(initialValue : observ.wrappedValue)
    }
}

struct ObservEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ObservEditor(eleve: .constant(TestEnvir.eleveStore.items.first!),
                         observ: .constant(TestEnvir.observStore.items.first!),
                         isNew: true)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            ObservEditor(eleve: .constant(TestEnvir.eleveStore.items.first!),
                         observ: .constant(TestEnvir.observStore.items.first!),
                         isNew: true)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}