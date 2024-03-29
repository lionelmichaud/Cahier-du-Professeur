//
//  ContentView.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var etabStore   : EtablissementStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore

    @SceneStorage("selectedTab")
    var selection = UIState.Tab.etablissement
    
    var body: some View {
        TabView(selection: $selection) {
            /// gestion des dossiers
            EtablissementSidebarView()
                .tabItem { Label("Etablissements", systemImage: "building.2").symbolVariant(.none) }
                .tag(UIState.Tab.etablissement)
                .badge(etabStore.nbOfItems)

            /// composition de la famille
            ClasseSidebarView()
                .tabItem { Label("Classes", systemImage: "person.3").symbolVariant(.none) }
                .tag(UIState.Tab.classe)
                .badge(classeStore.nbOfItems)

            /// dépenses de la famille
            EleveSidebarView()
                .tabItem { Label("Elèves", systemImage: "person").symbolVariant(.none) }
                .tag(UIState.Tab.eleve)
                .badge(eleveStore.nbOfItems)

            /// actifs & passifs du patrimoine de la famille
            ColleSidebarView()
                .tabItem { Label("Colles", systemImage: "lock").symbolVariant(.none) }
                .tag(UIState.Tab.colle)
                .badge(colleStore.nbOfItems)

            /// scenario paramètrique de simulation
            ObservSidebarView()
                .tabItem { Label("Observations", systemImage: "rectangle.and.text.magnifyingglass").symbolVariant(.none) }
                .tag(UIState.Tab.observation)
                .badge(observStore.nbOfItems)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return ContentView()
            .environmentObject(TestEnvir.etabStore)
            .environmentObject(TestEnvir.classStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colStore)
            .environmentObject(TestEnvir.obsStore)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
