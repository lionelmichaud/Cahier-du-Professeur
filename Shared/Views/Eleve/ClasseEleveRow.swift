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
                //.foregroundColor(eleve.niveau.color)
            Text(eleve.displayName)
            Spacer()
            Text("\(eleve.nbOfColles) colles")
            Spacer()
            Text("\(eleve.nbOfObservs) observations")
        }
    }
}

struct ClasseEleveRow_Previews: PreviewProvider {
    static var previews: some View {
        ClasseEleveRow(eleve: Eleve.exemple)
            .previewLayout(.sizeThatFits)
    }
}
