//
//  EtablissementEditor.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct EtablissementEditor: View {
    @Binding var etablissement: Etablissement
    var isNew = false

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EtablissementEditor_Previews: PreviewProvider {
    static var previews: some View {
        EtablissementEditor(etablissement: .constant(Etablissement.exemple))
    }
}
