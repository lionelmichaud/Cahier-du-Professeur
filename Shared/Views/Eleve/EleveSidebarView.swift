//
//  EleveSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct EleveSidebarView: View {
    var body: some View {
        NavigationView {
            /// Primary view
            EleveBrowserView()
            /// vue par défaut
            Text("Sélectionner une classe")
                .foregroundStyle(.secondary)
        }
    }
}

struct EleveSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        EleveSidebarView()
    }
}
