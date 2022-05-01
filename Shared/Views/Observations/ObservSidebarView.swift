//
//  ObservSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ObservSidebarView: View {
    var body: some View {
        NavigationView {
            /// Primary view
            ObservBrowserView()
            /// vue par défaut
            Text("Sélectionner une classe")
                .foregroundStyle(.secondary)
        }
    }
}

struct ObservSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ObservSidebarView()
    }
}
