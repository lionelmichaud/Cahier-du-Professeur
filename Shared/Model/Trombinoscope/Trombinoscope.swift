//
//  Trombinoscope.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 25/05/2022.
//

import Foundation
import os
import Files

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "Trombinoscope")

struct Trombinoscope {
    /// Construit l'URL de l'image trombine de l'élève à partir de son nom
    /// - Returns: URL de la trombine si le dossier Document existe sinon retourne `nil`.
    static func eleveTrombineUrl(eleve: Eleve) -> URL? {
        guard var familyName = eleve.name.familyName, let givenName = eleve.name.givenName else {
            return nil
        }

        if #available(iOS 16.0, macOS 13.0, *) {
            familyName = familyName.replacing(" ", with: "_")
        } else {
            familyName = familyName.replacingOccurrences(of: " ", with: "_", count: 2)
        }
        
        let imageName = familyName + "_" + givenName + ".jpg"

        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return nil
        }

        let fileURL = documentsFolder.url.appendingPathComponent(imageName)

        return fileURL
    }

    /// Supprimer le fichier photo JPEG associé à `eleve`
    static func deleteTrombine(eleve: Eleve) {
        guard let familyName = eleve.name.familyName, let givenName = eleve.name.givenName else {
            return
        }
        let name = familyName + "_" + givenName + ".jpg"

        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return
        }

        do {
            let file = try documentsFolder.file(named: name)
            try file.delete()
        } catch {
            // TODO: - Gérer l'exception
            customLog.log(level: .fault,
                          "\(error))")
        }
    }

    /// Supprimer tous les fichiers photo JPEG associés aux élèves
    static func deleteAllTrombines() {
        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return
        }

        documentsFolder.files.forEach { file in
            if file.extension == "jpg" {
                do {
                    try file.delete()
                } catch {
                    // TODO: - Gérer l'exception
                    customLog.log(level: .fault,
                                  "\(error))")
                }
            }
        }
    }
}
