//
//  Persistence.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 09/05/2022.
//

import Foundation
import os
import Files
import AppFoundation

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "PersistenceManager")

public enum FileError: String, Error {
    case failedToResolveAppBundle          = "Impossible de trouver le répertoire 'App Bundle'"
    case failedToResolveCsvFolder          = "Impossible de trouver le répertoire 'CSV'"
    case failedToResolveDocuments          = "Impossible de trouver le répertoire 'Documents' de l'utilisateur"
    case failedToResolveLibrary            = "Impossible de trouver le répertoire 'Library' de l'utilisateur"
    case directoryToDuplicateDoesNotExist  = "Le répertoire à dupliquer n'est pas défini"
    case failedToReadFile                  = "Echec de lecture du fichier"
    case failedToDuplicateFiles            = "Echec de la copie des fichiers"
    case templatesDossierNotInitialized    = "Dossier 'templates' non initializé"
    case failedToImportTemplates           = "Echec de l'importation des templates depuis Bundle.Main vers 'Library'"
    case failedToCheckCompatibility        = "Impossible de vérifier la compatibilité avec la version de l'application"
}

// MARK: - Extension de Folder

public extension Folder {
    // The current Application folder
    static var application: Folder? {
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }
        return try? Folder(path: resourcePath)
    }
}

public struct PersistenceManager {

    // MARK: - Methods

    public func collectedJsonURLs(fileNames : [String]?  = nil) throws -> [URL] {
        // vérifier l'existence du Folder associé au Dossier
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            throw error
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


    /// Importer les fichiers template depuis le `Bundle Main` de l'Application
    /// vers le répertoire `Documents` même si'ils y sont déjà présents.
    public func forcedImportAllJsonFilesFromApp() throws {
        guard let originFolder = Folder.application else {
            let error = FileError.failedToResolveAppBundle
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            throw error
        }

        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            throw error
        }

        do {
            try duplicateAllJsonFiles(from        : originFolder,
                                      to          : documentsFolder,
                                      forceUpdate : true)
        } catch {
            let error = FileError.failedToImportTemplates
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            throw error
        }
    }

    /// Dupliquer tous les fichiers `JSON` présents dans le répertoire `originFolder` vers le répertoire `targetFolder`
    ///
    /// Si `forceUpdate` = false : ne copie le fichier que s'il n'existe pas déjà dans `targetFolder`
    ///
    /// - Parameters:
    ///   - originFolder: répertoire source
    ///   - targetFolder: répertoire destination
    ///   - forceUpdate: si false alors ne copie pas les fichiers s'ils sont déjà présents dans le répertoire `targetFolder`
    /// - Throws:`FileError.failedToDuplicateFiles`
    fileprivate func duplicateAllJsonFiles(from originFolder : Folder,
                                           to targetFolder   : Folder,
                                           forceUpdate       : Bool = false) throws {
        do {
            try originFolder.files.forEach { originFile in
                if let ext = originFile.extension, ext == "json" {
                    // recopier le fichier s'il n'est pas présent dans le directory targetFolder
                    if !targetFolder.containsFile(named: originFile.name) || forceUpdate {
                        if originFile.name == AppVersion.fileName {
                            // enregister la version de l'app dans le directory targetFolder
                            try targetFolder.saveAsJSON(AppVersion.shared,
                                                        to                   : originFile.name,
                                                        dateEncodingStrategy : .iso8601,
                                                        keyEncodingStrategy  : .useDefaultKeys)
                        } else {
                            do {
                                let targetFile = try targetFolder.file(named: originFile.name)
                                try targetFile.delete()
                            } catch {
                            }
                            try originFile.copy(to: targetFolder)
                        }
                    }
                }
            }
        } catch {
            customLog.log(level: .fault,
                          "\(FileError.failedToDuplicateFiles.rawValue) de \(originFolder.name) vers \(targetFolder.name)")
            throw FileError.failedToDuplicateFiles
        }
    }
}
