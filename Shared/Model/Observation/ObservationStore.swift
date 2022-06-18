//
//  ObservationStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

typealias ObservationStore = JsonCodableArray<Observation>

extension ObservationStore {
    
    var nbOfItemsToCheck: Int {
        items.filter {
            $0.isVerified == false || $0.isConsignee == false
        }.count
    }

    func deleteObservation(withID: UUID) {
        items.removeAll {
            $0.id == withID
        }
        saveAsJSON()
    }

    func sort(observesID : inout [UUID]) {
        observesID = sorted(observesID: observesID)
    }

    func sorted(observesID : [UUID]) -> [UUID] {
        var observs = observesID.compactMap {
            item(withID: $0)
        }
        observs.sort(by: <)
        return observs.map { $0.id }
    }

    func sortedObservations(de eleve    : Eleve,
                            isConsignee : Bool? = nil,
                            isVerified  : Bool? = nil) -> Binding<[Observation]> {
        Binding<[Observation]>(
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
                for item in items {
                    self.update(with: item)
                }
            }
        )
    }

    func observations(de eleve    : Eleve,
                      isConsignee : Bool? = nil,
                      isVerified  : Bool? = nil) -> [Observation] {
        items.filter {
            if let eleveId = $0.eleveId {
                return (eleveId == eleve.id) && $0.satisfies(isConsignee : isConsignee,
                                                             isVerified  : isVerified)
            } else {
                return false
            }
        }
    }
}
