//
//  DocumentList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/11/2022.
//

import SwiftUI
import os
import Files
import HelpersView

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "DocumentList")

/// Vue de la liste des documents importants de l'établissement
struct DocumentList: View {
    @Binding
    var school: School

    @State
    private var isImportingPdfFile = false

    @State
    private var alertItem: AlertItem?

    var body: some View {
        Section {
            // ajouter une évaluation
            Button {
                isImportingPdfFile.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter un ou plusieurs documents")
                }
            }
            .buttonStyle(.borderless)
            /// Importer des fichiers JPEG
            .fileImporter(isPresented             : $isImportingPdfFile,
                          allowedContentTypes     : [.pdf],
                          allowsMultipleSelection : true) { result in
                importUserSelectedFiles(result: result)
            }
                          .alert(item: $alertItem, content: newAlert)

            // édition de la liste des événements
            ForEach($school.documents) { $document in
                DocumentRow(document: document)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let doc = school.documents[index]
                    let name = doc.fileName

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
                school.documents.remove(atOffsets: indexSet)
            }
            .onMove { fromOffsets, toOffset in
                school.documents.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }

        } header: {
            Text("Documents (\(school.nbOfDocuments))")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
    }

    // MARK: - Methods

    /// Copier les fichiers  sélectionnés dans le dossier Document de l'application.
    /// Ajouter un document à l'établissement pour chaque fichier importé.
    /// - Parameter result: résultat de la sélection des fichiers issue de fileImporter.
    private func importUserSelectedFiles(result: Result<[URL], Error>) {
        switch result {
            case .failure(let error):
                self.alertItem = AlertItem(title         : Text("Échec"),
                                           message       : Text("L'importation des fichiers a échoué"),
                                           dismissButton : .default(Text("OK")))
                print("Error selecting file: \(error.localizedDescription)")

            case .success(let filesUrl):
                ImportExportManager
                    .importURLsToDocumentsFolder(filesUrl: filesUrl) { file in
                        withAnimation {
                            // créer le document associé à l'établissement
                            school
                                .documents
                                .append(Document(filenameExcludingExtension : file.nameExcludingExtension,
                                                 fileExtension              : file.extension))
                        }
                    }
        }
    }
}

//struct DocumentList_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentList()
//    }
//}
