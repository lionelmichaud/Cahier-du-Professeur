//
//  ObservBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/04/2022.
//

import SwiftUI
import HelpersView

struct ObservBrowserRow: View {
    let eleve : Eleve
    var observ: Observation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(observ.color)
                Text("\(observ.date.stringShortDate) à \(observ.date.stringTime)")
                    .font(.callout)

                Spacer()

                ObservNotifIcon(observ: observ)
                ObservSignIcon(observ: observ)
            }

            EleveLabel(eleve: eleve)
                .font(.callout)
                .foregroundColor(.secondary)

            MotifLabel(motif: observ.motif)
                .font(.callout)
                //.foregroundColor(.secondary)
        }
    }
}

struct ObservBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                DisclosureGroup("Group", isExpanded: .constant(true)) {
                    ObservBrowserRow(eleve  : TestEnvir.eleveStore.items.first!,
                                     observ : TestEnvir.observStore.items.first!)
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
                }
            }
            .previewDevice("iPad mini (6th generation)")

            List {
                DisclosureGroup("Group", isExpanded: .constant(true)) {
                    ObservBrowserRow(eleve  : TestEnvir.eleveStore.items.first!,
                                     observ : TestEnvir.observStore.items.first!)
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
                }
            }
            .previewDevice("iPhone 13")
        }
    }
}
