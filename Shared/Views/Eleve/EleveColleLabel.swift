//
//  EleveColleLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct EleveColleLabel : View {
    let eleve: Eleve
    let scale: Image.Scale
    @EnvironmentObject private var colleStore : ColleStore

    private var nbCollesNonNotifee: Int {
        EleveManager().nbOfColles(de          : eleve,
                                  isConsignee : false,
                                  colleStore  : colleStore)
    }

    var body: some View {
        let nb = nbCollesNonNotifee
        return HStack {
            if nb > 0 {
                Text("\(nb)")
                Image(systemName: "lock.fill")
                    .imageScale(scale)
                    .foregroundColor(.red)
            }
        }
    }
}

struct EleveColleLabel_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            EleveColleLabel(eleve: TestEnvir.eleveStore.items.first!,
                            scale: .large)
                .previewLayout(.sizeThatFits)
                .environmentObject(TestEnvir.colleStore)

            EleveColleLabel(eleve: TestEnvir.eleveStore.items.first!,
                            scale: .medium)
                .previewLayout(.sizeThatFits)
                .environmentObject(TestEnvir.colleStore)

            EleveColleLabel(eleve: TestEnvir.eleveStore.items.first!,
                            scale: .small)
            .previewLayout(.sizeThatFits)
            .environmentObject(TestEnvir.colleStore)
       }
    }
}
