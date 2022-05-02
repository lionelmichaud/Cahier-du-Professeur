//
//  Colle.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct Colle: Identifiable, Codable {

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
    var motif       : Motif = Motif()
    var duree       : Int  = 1
    var isConsignee : Bool = false
    var isVerified  : Bool = false
    var date        : Date = Date.now

    var color: Color {
        satisfies(isConsignee: false) ? .red : .green
    }

    // MARK: - Initializers

    init(duree : Int     = 1,
         date  : Date    = Date.now) {
        self.duree = duree
        self.date  = date
    }

    // MARK: - Methods

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
