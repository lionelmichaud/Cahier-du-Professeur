//
//  Observation.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Observation: Identifiable, Codable {

    // MARK: - Type Methods

    static func < (lhs: Observation, rhs: Observation) -> Bool {
        if lhs.isConsignee != rhs.isConsignee {
            return !lhs.isConsignee
        } else if lhs.isVerified != rhs.isVerified {
            return !lhs.isVerified
        } else {
            return lhs.date > rhs.date
        }
    }

    // MARK: - Properties

    var id = UUID()
    var eleveId     : UUID?
    var motif       : Motif = Motif()
    var isConsignee : Bool  = false
    var isVerified  : Bool  = false
    var date        : Date  = Date.now

    // MARK: - Initializers

    init(date: Date = Date.now) {
        self.date = date
    }

    // MARK: - Methods

    /// True si l'observation satisfait à l'un des critères (OU logique)
    /// - Parameters:
    ///   - isConsignee: si `nil`, le critère n'est pas pris en compe
    ///   - isVerified: si `nil`, le critère n'est pas pris en compe
    func satisfies(isConsignee : Bool?  = nil,
                   isVerified  : Bool?  = nil) -> Bool {
        switch (isConsignee, isVerified) {
            case (nil, nil):
                return true

            case (.some(let c), nil):
                return self.isConsignee == c

            case (nil, .some(let v)):
                return self.isVerified == v

            case (.some(let c), .some(let v)):
                return self.isConsignee == c || self.isVerified == v
        }
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
           Motif    : \(String(describing: motif).withPrefixedSplittedLines("     "))
           Consignée: \(isConsignee.frenchString)
           Vérifiée : \(isVerified.frenchString)
        """
    }
}
