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

            VStack(alignment: .leading, spacing: 5) {
                Text(eleve.displayName)
                    .fontWeight(.bold)

//                HStack {
//                    Text("\(classe.nbOfEleves) élèves")
//                    Spacer()
//                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
//                }
//                .font(.caption)
//                .foregroundStyle(.secondary)
            }
        }
    }
}

struct EleveBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        EleveBrowserRow(eleve: Eleve.exemple)
            .previewLayout(.sizeThatFits)
    }
}
