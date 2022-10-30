//
//  ContentView.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI
import HelpersView

struct ContentView: View {
    @EnvironmentObject var schoolStore : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore

    @SceneStorage("navigation")
    private var navigationData: Data?
    @StateObject
    private var navigationModel = NavigationModel()

    @State
    private var alertItem: AlertItem?

    var body: some View {
        TabView(selection: $navigationModel.selectedTab) {
            /// gestion des dossiers
            SchoolSplitView()
                .tabItem { Label("Etablissement", systemImage: "building.2").symbolVariant(.none) }
                .tag(NavigationModel.Tab.school)
                .badge(schoolStore.nbOfItems)

            /// composition de la famille
            ClasseSplitView()
                .tabItem { Label("Classes", systemImage: "person.3").symbolVariant(.none) }
                .tag(NavigationModel.Tab.classe)
                .badge(classeStore.nbOfItems)

            /// dépenses de la famille
            EleveSplitView()
                .tabItem { Label("Elèves", systemImage: "person").symbolVariant(.none) }
                .tag(NavigationModel.Tab.eleve)
                .badge(eleveStore.nbOfItems)

            /// scenario paramètrique de simulation
            ObservSplitView()
                .tabItem { Label("Observations", systemImage: "rectangle.and.text.magnifyingglass").symbolVariant(.none) }
                .tag(NavigationModel.Tab.observation)
                .badge(observStore.nbOfItemsToCheck)

            /// actifs & passifs du patrimoine de la famille
            ColleSplitView()
                .tabItem { Label("Colles", systemImage: "lock").symbolVariant(.none) }
                .tag(NavigationModel.Tab.colle)
                .badge(colleStore.nbOfItemsToCheck)
        }
        .environmentObject(navigationModel)
        .alert(item: $alertItem, content: newAlert)
        .task {
            switch AppState.shared.initError {
                case .none:
                    break

                case .failedToLoadUserData,
                        .failedToInitialize,
                        .failedToLoadApplicationData,
                        .failedToCheckCompatibility:
                    self.alertItem = AlertItem(title         : Text("Erreur"),
                                               message       : Text(AppState.shared.initError!.rawValue),
                                               dismissButton : .default(Text("OK")))
            }
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
