//
//  ColleSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ColleSidebarView: View {
    var body: some View {
        NavigationSplitView {
            ColleBrowserView()
        } detail: {
            Text("Sélectionner une colle")
                .foregroundStyle(.secondary)
        }
    }
}

struct ColleSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ColleSidebarView()
    }
}
