//
//  ClasseObservLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct ClasseObservLabel: View {
    let classe: Classe
    let scale: Image.Scale
    @EnvironmentObject private var eleveStore : EleveStore
    @EnvironmentObject private var obserStore : ObservationStore

    private var nbObservNonNotifee: Int {
        ClasseManager().nbOfObservations(de          : classe,
                                         isConsignee : false,
                                         isVerified  : false,
                                         eleveStore  : eleveStore,
                                         observStore : obserStore)
    }

    var body: some View {
        let nb = nbObservNonNotifee
        return HStack {
            if nb > 0 {
                Text("\(nb)")
                Image(systemName: "magnifyingglass")
                    .imageScale(scale)
                    .foregroundColor(.red)
            }
        }
    }
}

struct ClasseObservLabel_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseObservLabel(classe: TestEnvir.classeStore.items.first!,
                              scale: .large)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)

            ClasseObservLabel(classe: TestEnvir.classeStore.items.first!,
                              scale: .medium)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)

            ClasseObservLabel(classe: TestEnvir.classeStore.items.first!,
                              scale: .small)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)
        }
    }
}
