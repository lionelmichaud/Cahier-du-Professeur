//
//  EtablissementSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct EtablissementSidebarView: View {
    var body: some View {
        NavigationView {
            /// Primary view
            EtablissementBrowserView()
            /// vue par défaut
            Text("Sélectionner un établissement")
                .foregroundStyle(.secondary)
        }
        //.navigationViewStyle(.columns)
    }
}

struct EtablissementSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return EtablissementSidebarView()
            .environmentObject(TestEnvir.etabStore)
            .environmentObject(TestEnvir.classStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colStore)
            .environmentObject(TestEnvir.obsStore)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
