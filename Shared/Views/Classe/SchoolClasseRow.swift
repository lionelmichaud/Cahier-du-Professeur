//
//  ClassRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolClasseRow: View {
    let classe: Classe

    var body: some View {
        HStack {
            Image(systemName: "person.3.sequence.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)
            Text(classe.displayString)
            if classe.isFlagged {
                Image(systemName: "flag.fill")
                    //.imageScale(.small)
                    .foregroundColor(.orange)
            }

            Spacer()

            Text("\(classe.nbOfEleves)")
            Image(systemName: "graduationcap")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)

            Spacer()

            Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) h")
        }
    }
}

struct SchoolClassRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                SchoolClasseRow(classe: Classe.exemple)
                SchoolClasseRow(classe: Classe.exemple)
            }
            .previewDevice("iPad mini (6th generation)")
            List {
                SchoolClasseRow(classe: Classe.exemple)
                SchoolClasseRow(classe: Classe.exemple)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
