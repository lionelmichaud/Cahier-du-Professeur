//
//  ClasseEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import HelpersView

struct ClasseEditor: View {
    @Binding
    var school: School
    @Binding
    var classe: Classe
    var isNew = false

    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Classe(niveau: .n6ieme, numero: 1)
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
        !classeStore.isPresent(classe) && !isNew
    }

    var body: some View {
        ClassDetail(classe    : $itemCopy,
                    isEditing : isEditing,
                    isNew     : true)
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
                        // Ajouter le nouvel établissement
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
                    } else {
                        // Appliquer les modifications faites à l'établissement
                        if isEditing && !isDeleted {
                            print("Done, saving any changes to \(classe.displayString).")
                            withAnimation {
                                classe = itemCopy // Put edits (if any) back in the store.
                                isSaved = true
                            }
                        }
                        isEditing.toggle()
                    }
                } label: {
                    Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                }
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }
}

struct ClasseEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EmptyView()
            ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                         classe : .constant(TestEnvir.classeStore.items.first!),
                         isNew  : true)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
        }
    }
}
