//
//  ClasseEleveRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI

struct ClasseEleveRow: View {
    let eleve: Eleve

    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)
            Text(eleve.displayName)

            Spacer()

            EleveColleLabel(eleve: eleve, scale: .large)
            EleveObservLabel(eleve: eleve, scale: .large)
        }
    }
}

struct ClasseEleveRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                ClasseEleveRow(eleve: TestEnvir.eleveStore.items.first!)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")
            
            List {
                ClasseEleveRow(eleve: TestEnvir.eleveStore.items.first!)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
