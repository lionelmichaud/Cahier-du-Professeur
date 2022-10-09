//
//  EleveEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI
import HelpersView

struct EleveEditor: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    // true si le mode édition est engagé
    @State
    private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State
    private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State
    private var isModified = false
    @State
    private var alertItem : AlertItem?

    private var selectedItemExists: Bool {
        guard let selectedEleve = navigationModel.selectedEleveId else {
            return false
        }
        return eleveStore.contains(selectedEleve)
    }

    var body: some View {
        if selectedItemExists {
            EleveDetail(eleve: eleveStore.itemBinding(withID: navigationModel.selectedEleveId!)!)
                .alert(item: $alertItem, content: newAlert)
        } else {
            VStack(alignment: .center) {
                Text("Aucun élève sélectionné.")
                Text("Sélectionner un élève.")
            }
            .foregroundStyle(.secondary)
            .font(.title)
        }
    }
}

struct EleveEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                EleveEditor()
                    .environmentObject(NavigationModel(selectedEleveId: TestEnvir.eleveStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                EleveEditor()
                    .environmentObject(NavigationModel(selectedEleveId: TestEnvir.eleveStore.items.first!.id))
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
