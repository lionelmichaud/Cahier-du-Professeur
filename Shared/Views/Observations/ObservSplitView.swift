//
//  ObservSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ObservSplitView: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var observStore     : ObservationStore

    var body: some View {
        NavigationSplitView(
            columnVisibility: $navigationModel.columnVisibility
        ) {
            ObservSidebarView()
        } detail: {
            ObservEditor()
        }
        .navigationSplitViewStyle(.balanced)
    }
}

struct ObservSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ObservSplitView()
    }
}
