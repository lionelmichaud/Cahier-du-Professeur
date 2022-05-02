//
//  ObservationManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveManager {

    // MARK: - Gestion des Observations

    func ajouter(observation  : inout Observation,
                 aEleve eleve : inout Eleve,
                 observStore  : ObservationStore) {
        observStore.insert(observation: observation, in: &eleve.observsID)
        observation.eleveId = eleve.id
        observStore.add(observation)
    }

    func retirer(observId          : UUID,
                 deEleveId eleveId : UUID,
                 eleveStore        : EleveStore) {
        guard let index = eleveStore.items.firstIndex(where: { $0.id == observId }) else {
            return
        }
        eleveStore.items[index].removeObservation(withID: observId)
    }

    func retirer(observIndex   : Int,
                 deEleve eleve : inout Eleve,
                 observStore   : ObservationStore) {
        // supprimer l'élève de la liste d'élèves
        observStore.deleteObservation(withID: eleve.observsID[observIndex])
        // supprimer l'élève de la eleve
        eleve.removeObservation(at: observIndex)
    }

    // MARK: - Gestion des Colles

    func ajouter(colle        : inout Colle,
                 aEleve eleve : inout Eleve,
                 colleStore   : ColleStore) {
        colleStore.insert(colle: colle, in: &eleve.collesID)
        colle.eleveId = eleve.id
        colleStore.add(colle)
    }

    func retirer(colleId           : UUID,
                 deEleveId eleveId : UUID,
                 eleveStore        : EleveStore) {
        guard let index = eleveStore.items.firstIndex(where: { $0.id == colleId }) else {
            return
        }
        eleveStore.items[index].removeColle(withID: colleId)
    }

    func retirer(colleIndex    : Int,
                 deEleve eleve : inout Eleve,
                 colleStore    : ColleStore) {
        // supprimer l'élève de la liste d'élèves
        colleStore.deleteColle(withID: eleve.collesID[colleIndex])
        // supprimer l'élève de la eleve
        eleve.removeColle(at: colleIndex)
    }

    // MARK: - Getters

    func nbOfObservations(de eleve     : Eleve,
                          isConsignee  : Bool? = nil,
                          isVerified   : Bool? = nil,
                          observStore  : ObservationStore) -> Int {
        switch (isConsignee, isVerified) {
            case (nil, nil):
                return eleve.nbOfObservs

            case (.some(let c), nil):
                return observStore
                    .observations(de: eleve)
                    .wrappedValue
                    .filter { $0.isConsignee == c }
                    .count

            case (nil, .some(let v)):
                return observStore
                    .observations(de: eleve)
                    .wrappedValue
                    .filter { $0.isVerified == v }
                    .count

            case (.some(let c), .some(let v)):
                return observStore
                    .observations(de: eleve)
                    .wrappedValue
                    .filter { $0.isConsignee == c || $0.isVerified == v }
                    .count
        }
    }

    func nbOfColles(de eleve    : Eleve,
                    isConsignee : Bool?  = nil,
                    isVerified  : Bool?  = nil,
                    colleStore  : ColleStore) -> Int {
        switch (isConsignee, isVerified) {
            case (nil, nil):
                return eleve.nbOfColles

            case (.some(let c), nil):
                return colleStore
                    .colles(de: eleve)
                    .wrappedValue
                    .filter { $0.isConsignee == c }
                    .count

            case (nil, .some(let v)):
                return colleStore
                    .colles(de: eleve)
                    .wrappedValue
                    .filter { $0.isVerified == v }
                    .count

            case (.some(let c), .some(let v)):
                return colleStore
                    .colles(de: eleve)
                    .wrappedValue
                    .filter { $0.isConsignee == c || $0.isVerified == v }
                    .count
        }
    }

    func filteredSortedEleves(dans classe       : Classe,
                              eleveStore        : EleveStore,
                              observStore       : ObservationStore,
                              colleStore        : ColleStore,
                              filterObservation : Bool,
                              filterColle       : Bool) -> Binding<[Eleve]> {
        eleveStore.filteredSortedEleves(dans: classe) { eleve in

            lazy var nbObservWithActionToDo : Int = {
                nbOfObservations(de          : eleve,
                                 isConsignee : false,
                                 isVerified  : false,
                                 observStore : observStore)
            }()
            lazy var nbColleWithActionToDo : Int = {
                nbOfColles(de          : eleve,
                           isConsignee : false,
                           colleStore  : colleStore)
            }()

            switch (filterObservation, filterColle) {
                case (false, false):
                    // on ne filtre pas
                    return true

                case (true, false):
                    return nbObservWithActionToDo > 0

                case (false, true):
                    return nbColleWithActionToDo > 0

                case (true, true):
                    return nbObservWithActionToDo + nbColleWithActionToDo > 0
            }
        }
    }
}
