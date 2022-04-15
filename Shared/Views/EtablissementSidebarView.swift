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
        .navigationViewStyle(.columns)
    }
}

struct EtablissementSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        EtablissementSidebarView()
            .environmentObject(EtablissementStore.exemple)
            .environmentObject(ClasseStore.exemple)
            .environmentObject(EleveStore.exemple)
            .environmentObject(ColleStore.exemple)
            .environmentObject(ObservationStore.exemple)
    }
}
