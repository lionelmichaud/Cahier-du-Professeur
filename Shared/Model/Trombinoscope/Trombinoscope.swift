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
        guard let familyName = eleve.name.familyName, let givenName = eleve.name.givenName else {
            return nil
        }
        let name = familyName + "_" + givenName + ".jpg"

        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return nil
        }

        let fileURL = documentsFolder.url.appendingPathComponent(name)
        print(fileURL)

        return fileURL
//        documentsFolder.files.forEach { file in
//            if let fileNames = fileNames {
//                fileNames.forEach { fileName in
//                    if file.name.contains(fileName) {
//                        urls.append(file.url)
//                    }
//                }
//            } else {
//                urls.append(file.url)
//            }
//        }
    }
}
