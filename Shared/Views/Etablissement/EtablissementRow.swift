//
//  EtablissementRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct EtablissementRow: View {
    let etablissement: Etablissement

    var body: some View {
        Text(etablissement.displayString)
    }
}

struct EtablissementRow_Previews: PreviewProvider {
    static var previews: some View {
        EtablissementRow(etablissement: Etablissement.exemple)
    }
}
