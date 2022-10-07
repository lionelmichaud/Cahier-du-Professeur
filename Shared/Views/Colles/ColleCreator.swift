//
//  ColleEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ColleCreator: View {
    @Binding
    var eleve: Eleve

    @State
    var colle: Colle = Colle()

    @EnvironmentObject private var eleveStore : EleveStore
    @EnvironmentObject private var colleStore : ColleStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ColleDetail(colle: $colle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem {
                    Button("Ajouter") {
                        // Ajouter une nouvelle colle à l'élève
                        withAnimation {
                            EleveManager()
                                .ajouter(colle      : &colle,
                                         aEleve     : &eleve,
                                         colleStore : colleStore)
                        }
                        dismiss()
                    }
                }
            }
    }
}

struct ColleCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ColleCreator(eleve: .constant(TestEnvir.eleveStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ColleCreator(eleve: .constant(TestEnvir.eleveStore.items.first!))
                    .environmentObject(NavigationModel(selectedColleId: TestEnvir.eleveStore.items.first!.id))
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
