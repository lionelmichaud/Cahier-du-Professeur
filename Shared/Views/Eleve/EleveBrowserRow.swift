//
//  EleveBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveBrowserRow: View {
    let eleve: Eleve
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)
            //            VStack(alignment: .leading, spacing: 5) {
            Text(eleve.displayName)
                .fontWeight(.semibold)
            Spacer()
            HStack {
                EleveColleLabel(eleve: eleve, scale: .small)
                EleveObservLabel(eleve: eleve, scale: .small)
            }
            //            }
        }
    }
}

struct EleveBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                DisclosureGroup("Group", isExpanded: .constant(true)) {
                    EleveBrowserRow(eleve: Eleve.exemple)
                        .environmentObject(TestEnvir.eleveStore)
                        .environmentObject(TestEnvir.colleStore)
                        .environmentObject(TestEnvir.observStore)
                }
            }
            .previewDevice("iPad mini (6th generation)")

            List {
                DisclosureGroup("Group", isExpanded: .constant(true)) {
                    EleveBrowserRow(eleve: Eleve.exemple)
                        .environmentObject(TestEnvir.eleveStore)
                        .environmentObject(TestEnvir.colleStore)
                        .environmentObject(TestEnvir.observStore)
                }
            }
            .previewDevice("iPhone 11")
        }
    }
}
