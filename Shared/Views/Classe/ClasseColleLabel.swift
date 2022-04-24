//
//  ClasseColleLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct ClasseColleLabel: View {
    let classe: Classe
    let scale: Image.Scale
    @EnvironmentObject private var eleveStore : EleveStore
    @EnvironmentObject private var colleStore : ColleStore

    private var nbCollesNonNotifee: Int {
        ClasseManager().nbOfColles(de          : classe,
                                   isConsignee : false,
                                   eleveStore  : eleveStore,
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

struct ClasseColleLabel_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseColleLabel(classe : TestEnvir.classeStore.items.first!,
                             scale  : .large)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)

            ClasseColleLabel(classe : TestEnvir.classeStore.items.first!,
                             scale  : .medium)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)

            ClasseColleLabel(classe : TestEnvir.classeStore.items.first!,
                             scale  : .small)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.observStore)
            .previewLayout(.sizeThatFits)
        }
    }
}
