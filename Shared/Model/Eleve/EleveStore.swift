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

    /// True si un élève existe déjà dans le strore  avec les mêmes
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
        Trombinoscope.deleteTrombine(eleve: eleve)
        saveAsJSON()
    }

    func filteredEleves
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
                self.update(with: items)
            }
        )
    }
    
    func filteredEleves
    (dans classe  : Classe,
     _ isIncluded : @escaping (Eleve) -> Bool = { _ in true}) -> [Eleve] {
        self.items
            .filter { eleve in
                if let classeId = eleve.classeId {
                    return (classeId == classe.id) && isIncluded(eleve)
                } else {
                    return false
                }
            }
        //.sorted(by: <)
    }

    func someObservations(dans classe : Classe,
                          observStore : ObservationStore,
                          isConsignee : Bool? = nil,
                          isVerified  : Bool? = nil) -> Bool {
        var found = false

        self.items.filter { eleve in
            eleve.classeId != nil && eleve.classeId == classe.id
        }
        .forEach { eleve in
            if !found {
                if observStore.observations(de          : eleve,
                                            isConsignee : isConsignee,
                                            isVerified  : isVerified).count != 0 {
                    found = true
                }
            }
        }

        return found
    }

    /// Retourne la liste des `Observation` associées aux élèves de la `classe`
    /// et qui sont stockées dans `observStore`
    /// et qui satsiafont aux critères: `isConsignee` et `isVerified`
    /// - Parameters:
    ///   - isConsignee: si `nil` on ne filtre pas, sinon on filtre sur la valeur booléenne
    ///   - isVerified: si `nil` on ne filtre pas, sinon on filtre sur la valeur booléenne
    /// - Returns: liste des `Observation` associées aux élèves de la `classe`
    func filteredSortedObservations
    (dans classe : Classe,
     observStore : ObservationStore,
     isConsignee : Bool? = nil,
     isVerified  : Bool? = nil) -> [Observation] {
        var observs = [Observation]()

        self.items.filter { eleve in
            eleve.classeId != nil && eleve.classeId == classe.id
        }
        .forEach { eleve in
            observs += observStore.observations(de          : eleve,
                                                isConsignee : isConsignee,
                                                isVerified  : isVerified)
        }

        return observs.sorted(by: <)
    }

    /// Retourne une liste de Binding sur des `Observation` associées aux élèves de la `classe`
    /// et qui sont stockées dans `observStore`
    /// et qui satsiafont aux critères: `isConsignee` et `isVerified`
    /// - Parameters:
    ///   - isConsignee: si `nil` on ne filtre pas, sinon on filtre sur la valeur booléenne
    ///   - isVerified: si `nil` on ne filtre pas, sinon on filtre sur la valeur booléenne
    /// - Returns: liste des `Observation` associées aux élèves de la `classe`
    func filteredSortedObservations
    (dans classe : Classe,
     observStore : ObservationStore,
     isConsignee : Bool? = nil,
     isVerified  : Bool? = nil) -> Binding<[Observation]> {

        Binding<[Observation]>(
            get: {
                var observs = [Observation]()

                self.items.filter { eleve in
                    eleve.classeId != nil && eleve.classeId == classe.id
                }
                .forEach { eleve in
                    observs += observStore.observations(de          : eleve,
                                                        isConsignee : isConsignee,
                                                        isVerified  : isVerified)
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

    func someColles(dans classe : Classe,
                    colleStore  : ColleStore,
                    isConsignee : Bool? = nil,
                    isVerified  : Bool? = nil) -> Bool {
        var found = false

        self.items.filter { eleve in
            eleve.classeId != nil && eleve.classeId == classe.id
        }
        .forEach { eleve in
            if !found {
                if colleStore.colles(de          : eleve,
                                     isConsignee : isConsignee,
                                     isVerified  : isVerified).count != 0 {
                    found = true
                }
            }
        }

        return found
    }

    func filteredSortedColles
    (dans classe : Classe,
     colleStore  : ColleStore,
     isConsignee : Bool? = nil,
     isVerified  : Bool? = nil) -> [Colle] {
        var colles = [Colle]()

        self.items.filter { eleve in
            eleve.classeId != nil && eleve.classeId == classe.id
        }
        .forEach { eleve in
            colles += colleStore.colles(de          : eleve,
                                        isConsignee : isConsignee,
                                        isVerified  : isVerified)
        }

        return colles.sorted(by: <)
    }

    func filteredSortedColles
    (dans classe : Classe,
     colleStore  : ColleStore,
     isConsignee : Bool? = nil,
     isVerified  : Bool? = nil) -> Binding<[Colle]> {

        Binding<[Colle]>(
            get: {
                var colles = [Colle]()

                self.items.filter { eleve in
                    eleve.classeId != nil && eleve.classeId == classe.id
                }
                .forEach { eleve in
                    colles += colleStore.colles(de          : eleve,
                                                isConsignee : isConsignee,
                                                isVerified  : isVerified)
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

}
