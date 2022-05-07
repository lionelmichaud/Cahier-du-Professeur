//
//  importCSV.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 07/05/2022.
//

import Foundation
import TabularData

enum CsvImporterError: Error {
    case incompatibleColumnNames
}

struct CsvImporter {
    func importEleves(from data: Data) throws -> [Eleve] {
        let nameColumn = ColumnID("Élève", String.self)
        let sexeColumn = ColumnID("Sexe", String.self)

        let columnNames = [nameColumn.name, sexeColumn.name]

        let options = CSVReadingOptions(hasHeaderRow      : true,
                                        nilEncodings      : ["", "nil"],
                                        ignoresEmptyLines : true,
                                        delimiter         : ";")

        var dataFrame = try DataFrame(csvData : data,
                                      columns : columnNames,
                                      types   : [nameColumn.name : .string,
                                                 sexeColumn.name : .string],
                                      options : options)

        let resolvedColumnsNames = Set(dataFrame.columns.map(\.name))
        guard resolvedColumnsNames.intersection(columnNames) == resolvedColumnsNames else {
            throw CsvImporterError.incompatibleColumnNames
        }

        dataFrame.transformColumn("Sexe") { data in
            data == "G" ? "male" : "female"
        }

        return dataFrame
            .filter(on: "Élève", String.self) {
                if let name = $0 {
                    return !name.contains("Eleve")
                } else {
                    return false
                }
            }
            .rows
            .compactMap { row in
                if let nom = row["Élève", String.self]?.split(separator: " ") {
                    return Eleve(sexe     : row["Sexe", String.self] == "male" ? .male   : .female,
                                 nom      : String(nom[0]),
                                 prenom   : String(nom.last!)
                    )
                } else {
                    return nil
                }
            }
    }
}
