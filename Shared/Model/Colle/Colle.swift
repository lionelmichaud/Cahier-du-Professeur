//
//  Colle.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Colle: Identifiable {

    // MARK: - Type Methods

    static func < (lhs: Colle, rhs: Colle) -> Bool {
        if lhs.isConsignee != rhs.isConsignee {
            return !lhs.isConsignee
        } else {
            return lhs.date > rhs.date
        }
    }

    // MARK: - Properties

    var id = UUID()
    var eleveId     : UUID?
    var duree       : Int  = 1
    var isConsignee : Bool = false
    var isVerified  : Bool = false
    var date        : Date = Date.now

    // MARK: - Initializers

    init(duree : Int     = 1,
         date  : Date    = Date.now) {
        self.duree = duree
        self.date  = date
    }

    static let exemple = Colle()
}

extension Colle: CustomStringConvertible {
    var description: String {
        """

        COLLE:
           Date     : \(date.stringShortDate)
           EleveID  : \(String(describing: eleveId))
           Durée    : \(duree) heures
           Consignée: \(isConsignee.frenchString)
           Vérifiée : \(isVerified.frenchString)
        """
    }
}
