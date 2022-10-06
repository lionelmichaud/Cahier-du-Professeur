//
//  ColleSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ColleSplitView: View {
    @EnvironmentObject private var navigationModel : NavigationModel

    var body: some View {
        NavigationSplitView(
            columnVisibility: $navigationModel.columnVisibility
        ) {
            ColleSidebarView()
        } detail: {
            ColleEditor()
        }
    }
}

struct ColleSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ColleSplitView()
    }
}
