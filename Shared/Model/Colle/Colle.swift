//
//  Colle.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class ColleStore: ObservableObject {
    @Published
    var items: [Colle] = [ ]
    var nbOfItems: Int {
        items.count
    }

    func exists(_ item: Colle) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    func add(_ item: Colle) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : Colle) {
        // zeroize du pointeur de la classe vers l'élève
        if let eleve = item.eleve {
            let colleManager = ColleManager()
            colleManager.retirer(colle: item,
                                 deEleve: eleve)
        }

        // retirer la colle de la liste
        items.removeAll {
            $0.id == item.id
        }
    }

    static var exemple : ColleStore = {
        let store = ColleStore()
        store.items.append(Colle.exemple)
        return store
    }()
}

extension ColleStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

final class Colle: ObservableObject, Identifiable {
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
