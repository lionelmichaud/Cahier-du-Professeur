//
//  Colle.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation
import AppFoundation

class Colle: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var eleve: Eleve?
    @Published
    var duree: Int = 1
    @Published
    var consignee: Bool = false
    @Published
    var verifiee: Bool = false
    @Published
    var date: Date = Date.now

    init(eleve : Eleve?  = nil,
         duree : Int     = 1,
         date  : Date    = Date.now) {
        self.eleve = eleve
        self.duree = duree
        self.date  = date
    }

    static let exemple = Colle(eleve : Eleve.exemple,
                               duree : 1,
                               date  : Date.now)
}

extension Colle: CustomStringConvertible {
    var description: String {
        """
        
        COLLE:
           Date: \(date.stringShortDate)
           Eleve: \(eleve?.displayName ?? "nil")
           Durée: \(duree) heures
           Consignée: \(consignee.frenchString)
           Vérifiée: \(verifiee.frenchString)
        """
    }
}
