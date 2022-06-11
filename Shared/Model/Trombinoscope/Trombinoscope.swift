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
    static func eleveTrombineUrl(eleve: Eleve) -> URL? {
        guard var familyName = eleve.name.familyName, let givenName = eleve.name.givenName else {
            return nil
        }

        familyName = familyName.replacingOccurrences(of: " ", with: "_", count: 2)

        let name = familyName + "_" + givenName + ".jpg"

        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return nil
        }

        let fileURL = documentsFolder.url.appendingPathComponent(name)

        return fileURL
    }

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
        }
    }

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
                }
            }
        }
    }

    static func importTrombines() {
        
    }
}
