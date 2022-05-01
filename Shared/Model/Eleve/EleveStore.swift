//
//  EleveStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI

final class EleveStore: ObservableObject {

    // MARK: - Properties

    @Published
    var items: [Eleve] = [ ]

    var nbOfItems: Int {
        items.count
    }

    // MARK: - Methods

    /// True si un élève existe dans le strore déjà avec les mêmes
    /// nom et prénom
    /// - Parameter eleve: Elève
    func exists(_ eleve: Eleve) -> Bool {
        items.contains {
            $0.isSameAs(eleve)
        }
    }

    /// True si un élève existe déjà dans la classe avec les mêmes
    /// nom et prénom
    /// - Parameter eleve: Elève
    /// - Parameter classeID: ID de la classe
    func exists(eleve        : Eleve,
                `in`classeID : UUID) -> Bool {
        var e = eleve
        e.classeId = classeID
        return items.contains {
            $0.isSameAs(e)
        }
    }

    /// True si un élève existe déjà avec le même ID
    /// - Parameter item: Eleve
    func isPresent(_ item: Eleve) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si un élève existe déjà avec le même ID
    /// - Parameter ID: ID de l'élève
    func isPresent(_ ID: UUID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    func eleve(withID ID: UUID) -> Eleve? {
        items.first(where: { ID == $0.id})
    }

    func add(_ item: Eleve) {
        items.insert(item, at: 0)
    }

    func deleteEleve(_ eleve     : Eleve,
                     observStore : ObservationStore,
                     colleStore  : ColleStore) {
        deleteEleve(withID      : eleve.id,
                    observStore : observStore,
                    colleStore  : colleStore)
    }

    func deleteEleve(withID id   : UUID,
                     observStore : ObservationStore,
                     colleStore  : ColleStore) {
        guard let eleve = eleve(withID: id) else {
            return
        }
        // supprimer toutes les observations et colles de l'élève
        eleve.observsID.forEach { observID in
            observStore.deleteObservation(withID: observID)
        }
        eleve.collesID.forEach { colleID in
            colleStore.deleteColle(withID: colleID)
        }
        // retirer l'élève de la liste
        items.removeAll {
            $0.id == eleve.id
        }
    }

    func insert(eleve         : Eleve,
                `in` elevesID : inout [UUID]) {
        guard elevesID.isNotEmpty else {
            elevesID = [eleve.id]
            return
        }

        guard let index = elevesID.firstIndex(where: {
            guard let c0 = self.eleve(withID: $0) else {
                return false
            }
            return eleve < c0
        }) else {
            elevesID.append(eleve.id)
            return
        }
        elevesID.insert(eleve.id, at: index)
    }

    func filteredSortedEleves
    (dans classe: Classe,
     _ isIncluded: @escaping (Eleve) -> Bool = { _ in true}) -> Binding<[Eleve]> {

        Binding<[Eleve]>(
            get: {
                self.items
                    .filter { eleve in
                        if let classeId = eleve.classeId {
                            return (classeId == classe.id) && isIncluded(eleve)
                        } else {
                            return false
                        }
                    }
                    .sorted(by: <)
            },
            set: { items in
                for classe in items {
                    if let index = self.items.firstIndex(where: { $0.id == classe.id }) {
                        self.items[index] = classe
                    }
                }
            }
        )
    }

    func filteredSortedObservations
    (dans classe : Classe,
     observStore : ObservationStore,
     _ isIncluded: @escaping (Observation) -> Bool = { _ in true}) -> Binding<[Observation]> {

        Binding<[Observation]>(
            get: {
                var observs = [Observation]()

                self.items.filter { eleve in
                    if let classeId = eleve.classeId {
                        return (classeId == classe.id)
                    } else {
                        return false
                    }
                }
                .forEach { eleve in
                    observStore
                        .observations(de: eleve)
                        .forEach { $observ in
                            if isIncluded(observ) {
                                observs.append(observ)
                            }
                    }
                }

                return observs.sorted(by: <)
            },
            set: { items in
                for observ in items {
                    if let index = observStore.items.firstIndex(where: { $0.id == observ.id }) {
                        observStore.items[index] = observ
                    }
                }
            }
        )
    }

    static var exemple : EleveStore = {
        let store = EleveStore()
        store.items.append(Eleve.exemple)
        return store
    }()
}

extension EleveStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

