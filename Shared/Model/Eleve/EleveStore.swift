//
//  EleveStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI

typealias EleveStore = JsonCodableArray<Eleve>

extension EleveStore {

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

    /// Supprimer toutes les observations et colles de l'élève
    /// puis retirer l'élève de la liste du store
    func deleteEleve(_ eleve     : Eleve,
                     observStore : ObservationStore,
                     colleStore  : ColleStore) {
        deleteEleve(withID      : eleve.id,
                    observStore : observStore,
                    colleStore  : colleStore)
    }

    /// Supprimer toutes les observations et colles de l'élève
    /// puis retirer l'élève de la liste du store
    func deleteEleve(withID id   : UUID,
                     observStore : ObservationStore,
                     colleStore  : ColleStore) {
        guard let eleve = item(withID: id) else {
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
        saveAsJSON()
    }

    func filteredSortedEleves
    (dans classe  : Classe,
     _ isIncluded : @escaping (Eleve) -> Bool = { _ in true}) -> Binding<[Eleve]> {

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
                    //.sorted(by: <)
            },
            set: { items in
                for classe in items {
                    if let index = self.items.firstIndex(where: { $0.id == classe.id }) {
                        self.items[index] = classe
                    }
                }
                self.saveAsJSON()
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
                        .forEach { observ in
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
                self.saveAsJSON()
            }
        )
    }

    func filteredSortedColles
    (dans classe : Classe,
     colleStore  : ColleStore,
     _ isIncluded: @escaping (Colle) -> Bool = { _ in true}) -> Binding<[Colle]> {

        Binding<[Colle]>(
            get: {
                var colles = [Colle]()

                self.items.filter { eleve in
                    if let classeId = eleve.classeId {
                        return (classeId == classe.id)
                    } else {
                        return false
                    }
                }
                .forEach { eleve in
                    colleStore
                        .colles(de: eleve)
                        .forEach { observ in
                            if isIncluded(observ) {
                                colles.append(observ)
                            }
                        }
                }

                return colles.sorted(by: <)
            },
            set: { items in
                for colle in items {
                    if let index = colleStore.items.firstIndex(where: { $0.id == colle.id }) {
                        colleStore.items[index] = colle
                    }
                }
                self.saveAsJSON()
            }
        )
    }

//    static var exemple : EleveStore = {
//        let store = EleveStore()
//        store.items.append(Eleve.exemple)
//        return store
//    }()
}
