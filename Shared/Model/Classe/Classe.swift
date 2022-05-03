//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Classe: Identifiable, Codable {

    // MARK: - Type Methods

    static func < (lhs: Classe, rhs: Classe) -> Bool {
        if lhs.niveau.rawValue != rhs.niveau.rawValue {
            return lhs.niveau.rawValue < rhs.niveau.rawValue
        } else {
            return lhs.numero < rhs.numero
        }
    }

    // MARK: - Properties

    var id = UUID()
    var schoolId     : UUID?
    var niveau       : NiveauClasse = .n6ieme
    var numero       : Int          = 1
    var heures       : Double       = 0
    var isFlagged    : Bool         = false
    var appreciation : String       = ""
    var elevesID     : [UUID]       = []

    var nbOfEleves: Int {
        elevesID.count
    }

    var elevesLabel: String {
        if nbOfEleves == 0 {
            return "Aucun Élève"
        } else if nbOfEleves == 1 {
            return "1 Élève"
        } else {
            return "\(nbOfEleves) Élèves"
        }
    }

    var displayString: String {
        "\(niveau.displayString)\(numero)"
    }

    // MARK: - Initializers

    init(schoolId : UUID?  = nil,
         niveau   : NiveauClasse,
         numero   : Int,
         heures   : Double = 0) {
        self.schoolId = schoolId
        self.niveau   = niveau
        self.numero   = numero
        self.heures   = heures
    }

    // MARK: - Methods

    func isSameAs(_ classe: Classe) -> Bool {
        self.niveau == classe.niveau &&
        self.numero == classe.numero &&
        self.schoolId == classe.schoolId
    }
    
    mutating func addEleve(withID eleveID: UUID) {
        elevesID.insert(eleveID, at: 0)
    }

    mutating func removeEleve(withID eleveID: UUID) {
        elevesID.removeAll(where: { $0 == eleveID })
    }

    mutating func removeEleve(at index : Int) {
        elevesID.remove(at: index)
    }

    mutating func moveEleve(from indexes: IndexSet, to destination: Int) {
        elevesID.move(fromOffsets: indexes, toOffset: destination)
    }

   static let exemple = Classe(niveau : .n6ieme,
                                numero : 1,
                                heures : 1.5)

}

extension Classe: CustomStringConvertible {
    var description: String {
        """
        
        CLASSE: \(displayString)
           ID      : \(id)
           Niveau  : \(niveau.displayString)
           Numéro  : \(numero)
           Heures  : \(heures)
           Flagged : \(isFlagged.frenchString)
           Appréciation: \(appreciation)
           SchoolID: \(String(describing: schoolId))
           Eleves  : \(String(describing: elevesID).withPrefixedSplittedLines("     "))
        """
    }
}

//extension Classe: Equatable {
//    static func == (lhs: Classe, rhs: Classe) -> Bool {
//        lhs.niveau == rhs.niveau &&
//        lhs.numero == rhs.numero &&
//        lhs.schoolId == rhs.schoolId
//    }
//}
