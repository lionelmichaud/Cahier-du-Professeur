//
//  SchoolSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct SchoolSidebarView: View {
    var body: some View {
        NavigationView {
            /// Primary view
            SchoolBrowserView()
            /// vue par défaut
            Text("Sélectionner un établissement")
                .foregroundStyle(.secondary)
        }
        //.navigationViewStyle(.columns)
    }
}

struct SchoolSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return SchoolSidebarView()
            .environmentObject(TestEnvir.etabStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
