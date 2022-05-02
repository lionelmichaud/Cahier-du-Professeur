//
//  ColleStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

final class ColleStore: ObservableObject {

    // MARK: - Properties

    @Published
    var items: [Colle] = [ ]
    
    var nbOfItems: Int {
        items.count
    }

    var nbOfItemsToCheck: Int {
        items.filter {
            $0.isConsignee == false
        }.count
    }

    /// True si une colle existe déjà avec le même ID
    /// - Parameter item: Eleve
    func isPresent(_ item: Colle) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si une colle existe déjà avec le même ID
    /// - Parameter ID: ID de l'élève
    func isPresent(_ ID: UUID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    func colle(withID ID: UUID) -> Colle? {
        items.first(where: { ID == $0.id})
    }

    func add(_ item: Colle) {
        items.insert(item, at: 0)
    }

    func deleteColle(withID: UUID) {
        items.removeAll {
            $0.id == withID
        }
    }

    func insert(colle           : Colle,
                `in` observesID : inout [UUID]) {
        guard observesID.isNotEmpty else {
            observesID = [colle.id]
            return
        }

        guard let index = observesID.firstIndex(where: {
            guard let c0 = self.colle(withID: $0) else {
                return false
            }
            return colle < c0
        }) else {
            observesID.append(colle.id)
            return
        }
        observesID.insert(colle.id, at: index)
    }

    func colles(de eleve    : Eleve,
                isConsignee : Bool? = nil,
                isVerified  : Bool? = nil) -> Binding<[Colle]> {
        Binding<[Colle]>(
            get: {
                self.items
                    .filter {
                        if let eleveId = $0.eleveId {
                            return (eleveId == eleve.id) && $0.satisfies(isConsignee : isConsignee,
                                                                         isVerified  : isVerified)
                        } else {
                            return false
                        }
                    }
                    .sorted(by: <)
            },
            set: { items in
                for colle in items {
                    if let index = self.items.firstIndex(where: { $0.id == colle.id }) {
                        self.items[index] = colle
                    }
                }
            }
        )
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

