//
//  Share.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 06/05/2022.
//

import SwiftUI
import HelpersView
import Files

func share(items      : [Any],
           activities : [UIActivity]?  = nil,
           animated   : Bool           = true,
           fromX      : Double?        = nil,
           fromY      : Double?        = nil) {
    let activityView = UIActivityViewController(activityItems: items,
                                                applicationActivities: activities)
    UIApplication.shared.windows.first?.rootViewController?.present(activityView,
                                                                    animated   : animated,
                                                                    completion : nil)

    if UIDevice.current.userInterfaceIdiom == .pad {
        activityView.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
        activityView.popoverPresentationController?.sourceRect = CGRect(
            x: (fromX == nil) ? UIScreen.main.bounds.width / 2.1 : fromX!,
            y: (fromY == nil) ? UIScreen.main.bounds.height / 2.3 : fromY!,
            width: 32,
            height: 32)
    }
}

func collectedURLs(fileNames : [String]?  = nil,
                   alertItem : inout AlertItem?) -> [URL] {
    // vérifier l'existence du Folder associé au Dossier
    guard let documentsFolder = Folder.documents else {
        alertItem = AlertItem(title         : Text("Echec de l'exportation: dossier Documents introuvable !"),
                              dismissButton : .default(Text("OK")))
        return [ ]
    }

    var urls = [URL]()
    // collecte des URL des fichiers contenus dans le dossier Documents
    documentsFolder.files.forEach { file in
        if let fileNames = fileNames {
            fileNames.forEach { fileName in
                if file.name.contains(fileName) {
                    urls.append(file.url)
                }
            }
        } else {
            urls.append(file.url)
        }
    }
    
    return urls
}

/// Partager les fichiers contenus dans le dossier actif de `dataStore`
/// et qui contiennent l'une des Strings de `fileNames`
/// ou bien tous les fichiers si `fileNames` = `nil`
/// - Parameters:
///   - dataStore: dataStore de l'application
///   - fileNames: permet d'identifier les fichiers à partager
///   - geometry: gemetry de la View qui appèle la fonction
func shareFiles(fileNames : [String]? = nil,
                alertItem : inout AlertItem?,
                geometry  : GeometryProxy) {
    let urls = collectedURLs(fileNames: fileNames,
                             alertItem: &alertItem)

    // partage des fichiers collectés
    if urls.isNotEmpty {
        share(items: urls,
              fromX: Double(geometry.frame(in: .global).maxX-32),
              fromY: 24.0)
    }
}