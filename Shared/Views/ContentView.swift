//
//  ContentView.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var schoolStore : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore

    @SceneStorage("navigation") private var navigationData: Data?
    @StateObject private var navigationModel = NavigationModel()

    var body: some View {
        TabView(selection: $navigationModel.selectedTab) {
            /// gestion des dossiers
            SchoolSidebarView()
                .tabItem { Label("Etablissement", systemImage: "building.2").symbolVariant(.none) }
                .tag(UIState.Tab.school)
                .badge(schoolStore.nbOfItems)

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

            /// scenario paramètrique de simulation
            ObservSplitView()
                .tabItem { Label("Observations", systemImage: "rectangle.and.text.magnifyingglass").symbolVariant(.none) }
                .tag(UIState.Tab.observation)
                .badge(observStore.nbOfItemsToCheck)

            /// actifs & passifs du patrimoine de la famille
            ColleSidebarView()
                .tabItem { Label("Colles", systemImage: "lock").symbolVariant(.none) }
                .tag(UIState.Tab.colle)
                .badge(colleStore.nbOfItemsToCheck)
        }
        .environmentObject(navigationModel)
        .task {
            eleveStore.sort()

            if let navigationData {
                navigationModel.jsonData = navigationData
            }
            for await _ in navigationModel.objectWillChangeSequence {
                navigationData = navigationModel.jsonData
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return ContentView()
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
