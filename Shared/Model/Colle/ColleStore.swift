//
//  ColleStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

typealias ColleStore = JsonCodableArray<Colle>

extension ColleStore {

    var nbOfItemsToCheck: Int {
        items.filter {
            $0.isConsignee == false
        }.count
    }

    func deleteColle(withID: UUID) {
        items.removeAll {
            $0.id == withID
        }
        saveAsJSON()
    }

    func sortedColles(de eleve    : Eleve,
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
                self.update(with: items)
            }
        )
    }

    func colles(de eleve    : Eleve,
                isConsignee : Bool? = nil,
                isVerified  : Bool? = nil) -> [Colle] {
        items.filter {
                if let eleveId = $0.eleveId {
                    return (eleveId == eleve.id) && $0.satisfies(isConsignee : isConsignee,
                                                                 isVerified  : isVerified)
                } else {
                    return false
                }
            }
            .sorted(by: <)
    }
}
