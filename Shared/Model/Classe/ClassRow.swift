//
//  ClassRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct ClassRow: View {
    var classe: Classe
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Classe de \(classe.displayString) de \(classe.nbOfEleves) élèves \(classe.id)")
        }
    }
}

struct ClassRow_Previews: PreviewProvider {
    static var previews: some View {
        ClassRow(classe: Classe.exemple)
            .previewLayout(.sizeThatFits)
        ClassRow(classe: Classe.exemple)
            .previewLayout(.sizeThatFits)
    }
}
