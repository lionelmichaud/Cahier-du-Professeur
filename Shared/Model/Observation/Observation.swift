//
//  Observation.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Observation: Identifiable {

    // MARK: - Type Methods

    static func < (lhs: Observation, rhs: Observation) -> Bool {
        if lhs.isVerified != rhs.isVerified {
            return !lhs.isVerified
        } else {
            return lhs.date > rhs.date
        }
    }

    // MARK: - Properties

    var id = UUID()
    var eleveId     : UUID?
    var isConsignee : Bool = false
    var isVerified  : Bool = false
    var date        : Date = Date.now

    // MARK: - Initializers

    init(date: Date = Date.now) {
        self.date = date
    }

    static let exemple = Observation()
}

extension Observation: CustomStringConvertible {
    var description: String {
        """

        OBSERVATION:
           ID       : \(id)
           Date     : \(date.stringShortDate)
           EleveID  : \(String(describing: eleveId))
           Consignée: \(isConsignee.frenchString)
           Vérifiée : \(isVerified.frenchString)
        """
    }
}
