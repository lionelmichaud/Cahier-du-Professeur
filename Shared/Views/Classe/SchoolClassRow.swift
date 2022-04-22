//
//  ClassRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolClassRow: View {
    var classe: Classe

    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)
            Text("Classe de \(classe.displayString)")
            Spacer()
            Text("\(classe.nbOfEleves) élèves")
            Spacer()
            Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
        }
    }
}

struct SchoolClassRow_Previews: PreviewProvider {
    static var previews: some View {
        SchoolClassRow(classe: Classe.exemple)
            .previewLayout(.sizeThatFits)
    }
}
