//
//  Observation.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class ObservationStore: ObservableObject {
    @Published
    var items: [Observation] = [ ]

    func add(_ item: Observation) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : Observation) {
        // zeroize du pointeur de la classe vers l'élève
        if let eleve = item.eleve {
            let observationManager = ObservationManager()
            observationManager.retirer(observ: item,
                                       deEleve: eleve)
        }

        // retirer l'observ de la liste
        items.removeAll {
            $0.id == item.id
        }
    }


    static let exemple : ObservationStore = {
        let store = ObservationStore()
        store.items.append(Observation.exemple)
        store.items.append(Observation.exemple)
        return store
    }()
}

extension ObservationStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

final class Observation: ObservableObject, Identifiable {
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

    static let exemple = Observation(eleve : Eleve.exemple,
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
