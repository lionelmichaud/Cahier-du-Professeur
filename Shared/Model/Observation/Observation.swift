//
//  Observation.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

class Observation: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var eleve: Eleve?
    @Published
    var consignee: Bool = false
    @Published
    var verifiee: Bool = false
    @Published
    var date: Date = Date.now

    init(eleve : Eleve?  = nil,
         date  : Date    = Date.now) {
        self.eleve = eleve
        self.date  = date
    }

    static let exemple = Colle(eleve : Eleve.exemple,
                               date  : Date.now)
}

extension Observation: CustomStringConvertible {
    var description: String {
        """

        OBSERVATION:
           Date: \(date.stringShortDate)
           Eleve: \(eleve?.displayName ?? "nil")
           Consignée: \(consignee.frenchString)
           Vérifiée: \(verifiee.frenchString)
        """
    }
}
