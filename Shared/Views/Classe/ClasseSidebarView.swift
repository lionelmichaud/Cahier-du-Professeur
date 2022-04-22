//
//  ClasseSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ClasseSidebarView: View {
    var body: some View {
        NavigationView {
            /// Primary view
            ClasseBrowserView()
            /// vue par défaut
            Text("Sélectionner une classe")
                .foregroundStyle(.secondary)
        }
    }
}

struct ClasseSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ClasseSidebarView()
    }
}
