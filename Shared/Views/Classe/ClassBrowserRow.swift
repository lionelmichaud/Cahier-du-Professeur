//
//  ClassRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/04/2022.
//

import SwiftUI
import HelpersView

struct ClassBrowserRow: View {
    var classe: Classe

    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)

            VStack(alignment: .leading, spacing: 5) {
                Text("Classe de \(classe.displayString)")
                    .fontWeight(.bold)

                HStack {
                    Text("\(classe.nbOfEleves) élèves")
                    Spacer()
                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}

struct ClassRow_Previews: PreviewProvider {
    static var previews: some View {
        ClassBrowserRow(classe: Classe.exemple)
            .previewLayout(.sizeThatFits)
    }
}
