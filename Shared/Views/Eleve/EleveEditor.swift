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
    var isNew = false

    @EnvironmentObject private var eleveStore : EleveStore
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

    var body: some View {
        EleveDetail(eleve      : $itemCopy,
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
                        // Appliquer les modifications faites à la classe
                        if isEditing && !isDeleted {
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
        .onDisappear {
            if isModified && !isSaved {
                // Appliquer les modifications faites à la classe hors du mode édition
                eleve = itemCopy
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }

    init(classe : Binding<Classe>,
         eleve  : Binding<Eleve>,
         isNew  : Bool = false) {
        self.isNew = isNew
        self._classe = classe
        self._eleve = eleve
        self._itemCopy = State(initialValue: eleve.wrappedValue)
    }
}

struct EleveEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                EleveEditor(classe: .constant(TestEnvir.classeStore.items.first!),
                            eleve: .constant(TestEnvir.eleveStore.items.first!),
                            isNew  : true)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationView {
                EleveEditor(classe: .constant(TestEnvir.classeStore.items.first!),
                            eleve: .constant(TestEnvir.eleveStore.items.first!),
                            isNew  : true)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 11")
       }
    }
}
