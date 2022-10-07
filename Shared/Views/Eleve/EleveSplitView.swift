//
//  EleveSplitView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 06/10/2022.
//

import SwiftUI

struct EleveSplitView: View {
    @EnvironmentObject private var navigationModel : NavigationModel

    var body: some View {
        NavigationSplitView(
            columnVisibility: $navigationModel.columnVisibility
        ) {
            EleveSidebarView()
        } detail: {
            EleveEditor()
        }
    }
}

struct EleveSplitView_Previews: PreviewProvider {
    static var previews: some View {
        EleveSplitView()
    }
}
