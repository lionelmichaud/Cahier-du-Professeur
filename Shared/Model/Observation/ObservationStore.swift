//
//  ObservationStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

final class ObservationStore: ObservableObject {
    
    // MARK: - Properties

    @Published
    var items: [Observation] = [ ]

    var nbOfItems: Int {
        items.count
    }

    var nbOfItemsToCheck: Int {
        items.filter {
            $0.isVerified == false || $0.isConsignee == false
        }.count
    }

    /// True si une observation existe déjà avec le même ID
    /// - Parameter item: Observation
    func isPresent(_ item: Observation) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si une observation existe déjà avec le même ID
    /// - Parameter ID: ID de l'Observation
    func isPresent(_ ID: UUID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    func observation(withID ID: UUID) -> Observation? {
        items.first(where: { ID == $0.id})
    }

    func add(_ item: Observation) {
        items.insert(item, at: 0)
    }

    func deleteObservation(withID: UUID) {
        items.removeAll {
            $0.id == withID
        }
    }

    func sort(observesID : inout [UUID]) {
        observesID = sorted(observesID: observesID)
    }

    func sorted(observesID : [UUID]) -> [UUID] {
        var observs = observesID.compactMap {
            observation(withID: $0)
        }
        observs.sort(by: <)
        return observs.map { $0.id }
    }

    func insert(observation     : Observation,
                `in` observesID : inout [UUID]) {
        guard observesID.isNotEmpty else {
            observesID = [observation.id]
            return
        }

        guard let index = observesID.firstIndex(where: {
            guard let c0 = self.observation(withID: $0) else {
                return false
            }
            return observation < c0
        }) else {
            observesID.append(observation.id)
            return
        }
        observesID.insert(observation.id, at: index)
    }

    func observations(de eleve    : Eleve,
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
                for observ in items {
                    if let index = self.items.firstIndex(where: { $0.id == observ.id }) {
                        self.items[index] = observ
                    }
                }
            }
        )
    }

    static var exemple : ObservationStore = {
        let store = ObservationStore()
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

