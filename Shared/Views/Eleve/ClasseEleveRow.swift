//
//  ClasseEleveRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI
import HelpersView

struct ClasseEleveRow: View {
    let eleve: Eleve

    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)
            Text(eleve.displayName)
            Spacer()
            Text("\(eleve.nbOfColles)")
            Image(systemName: "lock.fill")
                .foregroundColor(.red)
            Text("\(eleve.nbOfObservs)")
            Image(systemName: "magnifyingglass")
                .foregroundColor(.red)
        }
    }
}

struct ClasseEleveRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                ClasseEleveRow(eleve: Eleve.exemple)
                ClasseEleveRow(eleve: Eleve.exemple)
            }
            .previewDevice("iPad mini (6th generation)")
            List {
                ClasseEleveRow(eleve: Eleve.exemple)
                ClasseEleveRow(eleve: Eleve.exemple)
            }
            .previewDevice("iPhone 11")
        }
    }
}
