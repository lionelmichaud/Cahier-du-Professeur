//
//  ObservEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 06/10/2022.
//

import SwiftUI

struct ObservEditor: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var observStore     : ObservationStore

    private var selectedItemExists: Bool {
        guard let selectedObservId = navigationModel.selectedObservId else {
            return false
        }
        return observStore.contains(selectedObservId)
    }

    var body: some View {
        if selectedItemExists {
            ObservDetail(observ: observStore.itemBinding(withID: navigationModel.selectedObservId!)!)
        } else {
            VStack(alignment: .center) {
                Text("Aucune observation sélectionnée.")
                Text("Sélectionner une observation.")
            }
            .foregroundStyle(.secondary)
            .font(.title)
        }
    }
}

struct ObservEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ObservEditor()
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ObservEditor()
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
