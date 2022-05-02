//
//  EleveLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI
import HelpersView

struct EleveLabel: View {
    let eleve: Eleve

    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)
            Text(eleve.displayName)
                .fontWeight(.semibold)
            if eleve.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundColor(.orange)
            }
        }
    }
}

struct EleveLabel_Previews: PreviewProvider {
    static var previews: some View {
        EleveLabel(eleve: Eleve.exemple)
            .previewLayout(.sizeThatFits)
    }
}
