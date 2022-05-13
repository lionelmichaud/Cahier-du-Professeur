//
//  ExamEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 13/05/2022.
//

import SwiftUI

struct ExamEditor: View {
    @Binding
    var classe : Classe
    @Binding
    var exam   : Exam
    var isNew  : Bool

    @EnvironmentObject private var eleveStore  : EleveStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Exam()
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted  = false

    /// True si l'évaluation n'est pas dans le store ET si on est pas en train d'ajouter une nouvelle évaluation
    private var isItemDeleted: Bool {
        !classe.exams.contains(where: { $0.id == exam.id }) && !isNew
    }

    var body: some View {
        VStack {
            ExamDetail(exam       : $itemCopy,
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
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        if isNew {
                            // Ajouter une nouvelle évaluation à la classe
                            addNewItem()
                        } else {
                            // Appliquer les modifications faites à l'évaluation
                            if isEditing && !isDeleted {
                                print("Done, saving any changes to \(classe.displayString).")
                                withAnimation {
                                    exam = itemCopy // Put edits (if any) back in the store.
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
                itemCopy   = exam
                isModified = false
                isSaved    = false
            }
            .onDisappear {
                if isModified && !isSaved {
                    // Appliquer les modifications faites à la classe hors du mode édition
                    exam       = itemCopy
                    isModified = false
                    isSaved    = true
                }
            }
            .disabled(isItemDeleted)
        }
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Évaluation supprimée. Sélectionner une évaluation.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    init(classe: Binding<Classe>,
         exam  : Binding<Exam>,
         isNew : Bool = false) {
        self.isNew     = isNew
        self._classe   = classe
        self._exam     = exam
        self._itemCopy = State(initialValue : exam.wrappedValue)
    }

    private func addNewItem() {
        /// Ajouter une nouvelle évaluation
        withAnimation {
            classe.exams.insert(itemCopy, at: 0)
        }
        dismiss()
    }

}

struct ExamEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ExamEditor(classe : .constant(TestEnvir.classeStore.items.first!),
                       exam   : .constant(Exam()),
                       isNew  : true)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            ExamEditor(classe : .constant(TestEnvir.classeStore.items.first!),
                       exam   : .constant(Exam()),
                       isNew  : true)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}