//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Classe: Identifiable {

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
    var schoolId : UUID?
    var niveau   : NiveauClasse = .n6ieme
    var numero   : Int          = 1
    var heures   : Double       = 0
    private(set) var eleves: [UUID] = []

    var nbOfEleves: Int {
        eleves.count
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
           SchoolID: \(String(describing: schoolId))
           Eleves  : \(String(describing: eleves).withPrefixedSplittedLines("     "))
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
