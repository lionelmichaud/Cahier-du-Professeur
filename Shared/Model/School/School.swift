//
//  School.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct School: Identifiable, Equatable, Codable {

    // MARK: - Type Methods

    static func < (lhs: School, rhs: School) -> Bool {
        if lhs.niveau.rawValue != rhs.niveau.rawValue {
            return lhs.niveau.rawValue < rhs.niveau.rawValue
        } else {
            return lhs.nom < rhs.nom
        }
    }

    // MARK: - Properties

    var id = UUID()
    var niveau     : NiveauSchool = .college
    var nom        : String       = ""
    var annotation : String       = ""
    var classesID  : [UUID]       = []
    var ressources : [Ressource]  = []

    var nbOfClasses: Int {
        classesID.count
    }

    var nbOfRessources: Int {
        ressources.count
    }

    var classesLabel: String {
        if nbOfClasses == 0 {
            return "Aucune Classe"
        } else if nbOfClasses == 1 {
            return "1 Classe"
        } else {
            return "\(nbOfClasses) Classes"
        }
    }

    var ressourcesLabel: String {
        if nbOfRessources == 0 {
            return "Aucune Ressource"
        } else if nbOfRessources == 1 {
            return "1 Ressource"
        } else {
            return "\(nbOfRessources) Ressources"
        }
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

    func contains(classeId: UUID) -> Bool {
        self.classesID.contains(classeId)
    }

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
           Note   : \(annotation)
           Nombre de classes: \(nbOfClasses)
           ClassesID: \(String(describing: classesID).withPrefixedSplittedLines("     "))
        """
    }
}
