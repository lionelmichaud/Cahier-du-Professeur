//
//  Cahier_du_ProfesseurApp.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

@main
struct Cahier_du_ProfesseurApp: App {
    @StateObject private var etabStore   = SchoolStore()
    @StateObject private var classeStore = ClasseStore()
    @StateObject private var eleveStore  = EleveStore()
    @StateObject private var colleStore  = ColleStore()
    @StateObject private var observStore = ObservationStore()

    var body: some Scene {
        MainScene(etabStore   : etabStore  ,
                  classeStore : classeStore,
                  eleveStore  : eleveStore ,
                  colleStore  : colleStore ,
                  observStore : observStore)
    }

    init() {
    }
}

