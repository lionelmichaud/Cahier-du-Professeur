//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Classe: Identifiable {

    // MARK: - Properties

    var id = UUID()
    var schoolId : UUID?
    var niveau   : NiveauClasse = .n6ieme
    var numero   : Int          = 1
    private(set) var eleves: [UUID] = []

    var nbOfEleves: Int {
        eleves.count
    }

    var displayString: String {
        "\(niveau.displayString)\(numero)"
    }

    // MARK: - Initializers

    internal init(schoolId : UUID?  = nil,
                  niveau   : NiveauClasse,
                  numero   : Int) {
        self.schoolId = schoolId
        self.niveau   = niveau
        self.numero   = numero
    }

    static let exemple = Classe(niveau : .n6ieme,
                                numero : 1)

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
