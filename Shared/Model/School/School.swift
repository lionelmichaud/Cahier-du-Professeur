//
//  School.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct School: Identifiable, Equatable {

    // MARK: - Properties

    var id = UUID()
    var niveau    : NiveauSchool = .college
    var nom       : String       = ""
    var classesID : [UUID] = []

    var nbOfClasses: Int {
        classesID.count
    }

    var displayString: String {
        "\(niveau.displayString) \(nom)"
    }

    // MARK: - Initializers

    init(niveau : NiveauSchool = .college,
         nom    : String = "") {
        self.niveau = niveau
        self.nom = nom
    }

    // MARK: - Methods

    mutating func addClasse(withID classeID: UUID) {
        classesID.insert(classeID, at: 0)
    }

    mutating func removeClasse(withID classeID: UUID) {
        classesID.removeAll(where: { $0 == classeID })
    }

    mutating func removeClasse(at index : Int) {
        classesID.remove(at: index)
    }

    mutating func moveClasse(from indexes: IndexSet, to destination: Int) {
        classesID.move(fromOffsets: indexes, toOffset: destination)
    }

    static var exemple = School(niveau: .college, nom: "Galilée")
}

extension School: CustomStringConvertible {
    var description: String {
        """
        
        ETABLISSEMENT: \(displayString)
           ID     : \(id)
           Niveau : \(niveau.displayString)
           Nom    : \(nom)
           Nombre de classes: \(nbOfClasses)
           ClassesID: \(String(describing: classesID).withPrefixedSplittedLines("     "))
        """
    }
}
