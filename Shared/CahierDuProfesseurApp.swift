//
//  Cahier_du_ProfesseurApp.swift
//  Shared
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI
import os
import Files
import FileAndFolder
import HelpersView

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "Main")

@main
struct CahierDuProfesseurApp: App {
    @StateObject private var schoolStore = SchoolStore(fromFolder: nil)
    @StateObject private var classeStore = ClasseStore(fromFolder: nil)
    @StateObject private var eleveStore  = EleveStore(fromFolder: nil)
    @StateObject private var colleStore  = ColleStore(fromFolder: nil)
    @StateObject private var observStore = ObservationStore(fromFolder: nil)
    @State
    private var alertItem: AlertItem?

    var body: some Scene {
        MainScene(schoolStore : schoolStore,
                  classeStore : classeStore,
                  eleveStore  : eleveStore,
                  colleStore  : colleStore,
                  observStore : observStore)
    }

    /// Vérifier l'existance du dossier `Documents`.
    /// Vérifier la compatibilité de version entre l'application et les documents utilisateurs
    ///
    /// Si l'application et les documents utilisateurs ne sont pas compatible alors
    /// importer les documents contenus dans le Bundle application.
    init() {
        URLCache.shared.memoryCapacity = 100_000_000 // ~100 MB memory space

        /// vérifier l'existance du dossier `Documents`
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault, "\(error.rawValue))")
            fatalError()
        }

        /// vérifier la compatibilité de version entre l'application et les documents utilisateurs
        do {
            let documentsAreCompatibleWithAppVersion = try PersistenceManager.checkCompatibilityWithAppVersion(of: documentsFolder)
            print("Compatibilité : \(documentsAreCompatibleWithAppVersion)")
            if !documentsAreCompatibleWithAppVersion {
                do {
                    print("Importation des fichiers du Bundle de l'Application")
                    try PersistenceManager().forcedImportAllFilesFromApp(fileExt: "json")
                    try PersistenceManager().forcedImportAllFilesFromApp(fileExt: "jpg")
                    try PersistenceManager().forcedImportAllFilesFromApp(fileExt: "png")
                } catch {
                    self.alertItem = AlertItem(title         : Text("Erreur"),
                                               message       : Text("L'importation des fichiers a échouée!"),
                                               dismissButton : .default(Text("OK")))
                }
            }
        } catch {
            let error = FileError.failedToCheckCompatibility
            customLog.log(level: .fault, "\(error.rawValue))")
            fatalError()
        }
    }
}
