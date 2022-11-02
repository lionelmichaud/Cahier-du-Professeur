//
//  Share.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 06/05/2022.
//

import SwiftUI
import HelpersView
import Files

struct ImportExportManager {

//    static func share(items      : [Any],
//                      activities : [UIActivity]?  = nil,
//                      animated   : Bool           = true,
//                      fromX      : Double?        = nil,
//                      fromY      : Double?        = nil) {
//        let activityView = UIActivityViewController(activityItems: items,
//                                                    applicationActivities: activities)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityView,
//                                                                        animated   : animated,
//                                                                        completion : nil)
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            activityView.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
//            activityView.popoverPresentationController?.sourceRect = CGRect(
//                x: (fromX == nil) ? UIScreen.main.bounds.width / 2.1 : fromX!,
//                y: (fromY == nil) ? UIScreen.main.bounds.height / 2.3 : fromY!,
//                width: 32,
//                height: 32)
//        }
//    }
//
//    /// Partager les fichiers contenus dans le dossier actif de `dataStore`
//    /// et qui contiennent l'une des Strings de `fileNames`
//    /// ou bien tous les fichiers si `fileNames` = `nil`
//    /// - Parameters:
//    ///   - dataStore: dataStore de l'application
//    ///   - fileNames: permet d'identifier les fichiers à partager (par exemple .json)
//    ///   - geometry: gemetry de la View qui appèle la fonction
//    static func shareFiles(fileNames : [String]? = nil,
//                           alertItem : inout AlertItem?,
//                           geometry  : GeometryProxy) {
//        var urls: [URL] = []
//
//        do {
//            urls = try PersistenceManager().collectedURLs(fileNames: fileNames)
//        } catch {
//            alertItem = AlertItem(title         : Text("Echec de l'exportation: dossier Documents introuvable !"),
//                                  dismissButton : .default(Text("OK")))
//        }
//
//        // partage des fichiers collectés
//        if urls.isNotEmpty {
//            share(items: urls,
//                  fromX: Double(geometry.frame(in: .global).maxX-32),
//                  fromY: 24.0)
//        }
//    }

    /// Fournit la litse des URL des fichiers contenus dans le dossier Document
    /// et qui contiennent `fileNames`dans leur nom de fichier.
    /// - Parameter fileNames: critère de collecte (par exemple ".json")
    static func documentsURLsToShare(fileNames : [String]? = nil) -> [URL] {
        do {
            return try PersistenceManager().collectedURLs(fileNames: fileNames)
        } catch {
            // TODO: - Logger une ereur
            return [ ]
        }
    }

    /// Importer les fichiers dont les URL sont `filesUrl`vers le dossier Document
    /// - Parameter filesUrl: URLs des fichiers à importer
    static func importURLsToDocumentsFolder(filesUrl: [URL]) {
        guard let documentsFolder = Folder.documents else { return }

        filesUrl.forEach { fileUrl in
            guard fileUrl.startAccessingSecurityScopedResource() else { return }

            if let imageFile = try? File(path: fileUrl.path) {
                do {
                    if !documentsFolder.contains(imageFile) {
                        try imageFile.copy(to: documentsFolder)
                    }
                } catch let error {
                    print("Error reading file \(error.localizedDescription)")
                }
            }

            fileUrl.stopAccessingSecurityScopedResource()
        }
    }
}
