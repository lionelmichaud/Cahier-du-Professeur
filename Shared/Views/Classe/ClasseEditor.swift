//
//  ClasseEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import Files
import HelpersView

struct ClasseEditor: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var classeStore     : ClasseStore

    // MARK: - Computed Properties

    private var selectedItemExists: Bool {
        guard let selectedClasse = navigationModel.selectedClasseId else {
            return false
        }
        return classeStore.contains(selectedClasse)
    }

    var body: some View {
        if selectedItemExists {
            ClasseDetail(classe: classeStore.itemBinding(withID: navigationModel.selectedClasseId!)!)
        } else {
            VStack(alignment: .center) {
                Text("Aucune classe sélectionnée.")
                Text("Sélectionner une classe.")
            }
            .foregroundStyle(.secondary)
            .font(.title)
        }
    }
}

struct ClasseEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ClasseEditor()
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ClasseEditor()
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
