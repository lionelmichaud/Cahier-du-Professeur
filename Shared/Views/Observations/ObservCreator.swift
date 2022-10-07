//
//  ObservCreator.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ObservCreator: View {
    @Binding
    var eleve: Eleve

    @State
    private var observ: Observation = Observation()

    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ObservDetail(observ: $observ)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem {
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

struct ObservCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ObservCreator(eleve: .constant(TestEnvir.eleveStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ObservCreator(eleve: .constant(TestEnvir.eleveStore.items.first!))
                    .environmentObject(NavigationModel(selectedObservId: TestEnvir.observStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
