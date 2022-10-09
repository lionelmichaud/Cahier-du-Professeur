//
//  ClasseAcronym.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 09/10/2022.
//

import SwiftUI

struct ClasseAcronym: View {
    var classe: Classe

    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)
            Text(classe.displayString)
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}

struct ClasseAcronym_Previews: PreviewProvider {
    static var previews: some View {
        ClasseAcronym(classe: Classe.exemple)
    }
}
