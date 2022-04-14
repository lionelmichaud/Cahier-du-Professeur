//
//  ContentView.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedTab") var selection = UIState.Tab.etablissement
    
    var body: some View {
        TabView(selection: $selection) {
            /// gestion des dossiers
            EtablissementSidebarView()
                .tabItem { Label("Etablissements", systemImage: "building").symbolVariant(.none) }
                .tag(UIState.Tab.etablissement)

            /// composition de la famille
            ClasseSidebarView()
                .tabItem { Label("Classes", systemImage: "person.3").symbolVariant(.none) }
                .tag(UIState.Tab.classe)

            /// dépenses de la famille
            EleveSidebarView()
                .tabItem { Label("Elèves", systemImage: "person").symbolVariant(.none) }
                .tag(UIState.Tab.eleve)

            /// actifs & passifs du patrimoine de la famille
            ColleSidebarView()
                .tabItem { Label("Colles", systemImage: "lock").symbolVariant(.none) }
                .tag(UIState.Tab.colle)

            /// scenario paramètrique de simulation
            ObservSidebarView()
                .tabItem { Label("Observations", systemImage: "rectangle.and.text.magnifyingglass").symbolVariant(.none) }
                .tag(UIState.Tab.observation)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
