//
//  Cahier_du_ProfesseurApp.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

@main
struct Cahier_du_ProfesseurApp: App {
    @StateObject private var schoolStore = SchoolStore(fromFolder: nil)
    @StateObject private var classeStore = ClasseStore(fromFolder: nil)
    @StateObject private var eleveStore  = EleveStore(fromFolder: nil)
    @StateObject private var colleStore  = ColleStore(fromFolder: nil)
    @StateObject private var observStore = ObservationStore(fromFolder: nil)

    var body: some Scene {
        MainScene(schoolStore : schoolStore,
                  classeStore : classeStore,
                  eleveStore  : eleveStore,
                  colleStore  : colleStore,
                  observStore : observStore)
    }

    init() {
    }
}

