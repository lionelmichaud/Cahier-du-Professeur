//
//  EleveObservLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct EleveObservLabel: View {
    let eleve: Eleve
    let scale: Image.Scale
    @EnvironmentObject private var obserStore : ObservationStore

    private var nbObservNonNotifee: Int {
        EleveManager().nbOfObservations(de          : eleve,
                                        isConsignee : false,
                                        isVerified  : false,
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

struct EleveObservLabel_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            EleveObservLabel(eleve: TestEnvir.eleveStore.items.first!,
                             scale: .large)
            .previewLayout(.sizeThatFits)
            .environmentObject(TestEnvir.observStore)

            EleveObservLabel(eleve: TestEnvir.eleveStore.items.first!,
                             scale: .medium)
            .previewLayout(.sizeThatFits)
            .environmentObject(TestEnvir.observStore)

            EleveObservLabel(eleve: TestEnvir.eleveStore.items.first!,
                             scale: .small)
            .previewLayout(.sizeThatFits)
            .environmentObject(TestEnvir.observStore)
        }
    }
}
