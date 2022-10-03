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

    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    private var isItemDeleted: Bool {
        !observStore.contains(observ) && !isNew
    }

    var body: some View {
        ObservDetail(observ: $observ)
            .disabled(isItemDeleted)
            .toolbar {
                if isNew {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Annuler") {
                            dismiss()
                        }
                    }
                    ToolbarItem {
                        if isNew {
                            Button("Ajouter") {
                                // Ajouter une nouvelle observation à l'élève
                                withAnimation {
                                    EleveManager()
                                        .ajouter(observation : &observ,
                                                 aEleve      : &eleve,
                                                 observStore : observStore)
                                }
                                dismiss()
                            }
                        }
                    }
                }
            }
            .overlay(alignment: .center) {
                if isItemDeleted {
                    Color(UIColor.systemBackground)
                    Text("Observation supprimée. Sélectionner une observation.")
                        .foregroundStyle(.secondary)
                }
            }
    }
}

struct ObservEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ObservEditor(eleve  : .constant(TestEnvir.eleveStore.items.first!),
                         observ : .constant(TestEnvir.observStore.items.first!),
                         isNew  : true)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            ObservEditor(eleve  : .constant(TestEnvir.eleveStore.items.first!),
                         observ : .constant(TestEnvir.observStore.items.first!),
                         isNew  : true)
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}
