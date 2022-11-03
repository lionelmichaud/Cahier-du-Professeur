//
//  Document.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/11/2022.
//

import Foundation

struct Document : Identifiable, Hashable, Codable {

    // MARK: - Type Properties

    static let exemple = Document(
        docName                    : "Ceci est un exemple de document",
        filenameExcludingExtension : "document",
        fileExtension              : "pdf"
    )

    // MARK: - Properties

    var id = UUID()
    var docName                    : String
    var filenameExcludingExtension : String
    var fileExtension              : String?

    // MARK: - Computed Properties

    /// URL du fichier associé au document
    var url: URL {
        let ext = fileExtension == nil ? "" : ".\(fileExtension!)"
        return URL
            .documentsDirectory
            .appending(path: filenameExcludingExtension + ext)
    }

    /// Nom du fichier associé au document
    var fileName: String {
        let ext = fileExtension == nil ? "" : ".\(fileExtension!)"
        return filenameExcludingExtension + ext
    }

    // MARK: - Initializers

    init(
        docName                    : String?  = nil,
        filenameExcludingExtension : String,
        fileExtension              : String?  = nil
    ) {
        self.filenameExcludingExtension = filenameExcludingExtension
        self.fileExtension              = fileExtension
        if let docName {
            self.docName = docName
        } else {
            self.docName = filenameExcludingExtension
        }
    }
}
