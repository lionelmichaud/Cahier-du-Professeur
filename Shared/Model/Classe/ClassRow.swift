//
//  ClassRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct ClassRow: View {
    @Binding var classe: Classe
    var isEditing: Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ClassRow_Previews: PreviewProvider {
    static var previews: some View {
        ClassRow(classe: .constant(Classe.exemple), isEditing: false)
        ClassRow(classe: .constant(Classe.exemple), isEditing: true)
    }
}
