//
//  MainScene.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

/// Defines the main scene of the App
struct MainScene: Scene {

    // MARK: - Environment Properties

    @Environment(\.scenePhase) var scenePhase

    // MARK: - Properties

    @ObservedObject var schoolStore : SchoolStore
    @ObservedObject var classeStore : ClasseStore
    @ObservedObject var eleveStore  : EleveStore
    @ObservedObject var colleStore  : ColleStore
    @ObservedObject var observStore : ObservationStore

    /// object that you want to use throughout your views and that will be specific to each scene
    //@StateObject private var uiState = UIState()

    var body: some Scene {
        WindowGroup {
            /// defines the views hierachy of the scene
            ContentView()
                .environmentObject(schoolStore)
                .environmentObject(classeStore)
                .environmentObject(eleveStore)
                .environmentObject(colleStore)
                .environmentObject(observStore)
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
                case .active:
                    // An app or custom scene in this phase contains at least one active scene instance.
                    break
//                    print("Scene Phase = .active")

                case .inactive:
                    // An app or custom scene in this phase contains no scene instances in the ScenePhase.active phase.
                    break
//                    print("Scene Phase = .inactive")

                case .background:
                    // Expect an app that enters the background phase to terminate.
                    break
//                    print("Scene Phase = .background")

                @unknown default:
                    fatalError()
            }
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}
