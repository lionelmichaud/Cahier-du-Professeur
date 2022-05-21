//
//  ObservationManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

/// Gestion des élèves et de leurs liens avec leurs dépendants (classe, observaions, colles...)
struct EleveManager {

    // MARK: - Gestion des Observations

    /// Ajouter une `observation`à un `eleve` et à la liste des observations du store `observStore`
    /// - Parameters:
    ///   - observation: nouvelle observation de `eleve`
    ///   - eleve: élève auquel ajouter la nouvelle `observation`
    ///   - observStore: store des observations
    func ajouter(observation  : inout Observation,
                 aEleve eleve : inout Eleve,
                 observStore  : ObservationStore) {
        observStore.insert(item: observation, in: &eleve.observsID)
        observation.eleveId = eleve.id
        observStore.add(observation)
    }

    /// Détruire une observation d'ID'`observId` de la liste des observations du store `observStore`
    /// puis retirer l'observation de l'élève d'ID `eleveId` qui fait l'objet de  l'observation
    /// - Parameters:
    ///   - observId: ID de l'observation à supprimer
    ///   - eleveId: élève qui fait l'objet de  l'observation
    ///   - eleveStore: store des élèves
    func retirer(observId          : UUID,
                 deEleveId eleveId : UUID,
                 eleveStore        : EleveStore,
                 observStore       : ObservationStore) {
        // Détruire une observation d'ID'`observId` de la liste des observations du store `observStore`
        observStore.deleteObservation(withID: observId)
        
        // retirer l'observation de l'élève d'ID `eleveId` qui fait l'objet de  l'observation
        guard let indexEleve = eleveStore.items.firstIndex(where: { $0.id == eleveId }) else {
            return
        }
        eleveStore.items[indexEleve].removeObservation(withID: observId)
    }

    /// Détruire une observation à la position `observIndex`de la liste des observations du store `observStore`
    /// puis retirer l'observation de `eleve` auquel  elle appartient
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
        colleStore.insert(item: colle, in: &eleve.collesID)
        colle.eleveId = eleve.id
        colleStore.add(colle)
    }

    func retirer(colleId           : UUID,
                 deEleveId eleveId : UUID,
                 eleveStore        : EleveStore,
                 colleStore        : ColleStore) {
        // Détruire une colle d'ID'`colleId` de la liste des colles du store `colleStore`
        colleStore.deleteColle(withID: colleId)

        // retirer la colle de l'élève d'ID `eleveId` qui fait l'objet de  l'observation
        guard let indexEleve = eleveStore.items.firstIndex(where: { $0.id == colleId }) else {
            return
        }
        eleveStore.items[indexEleve].removeColle(withID: colleId)
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
                    .reduce(into: 0) { partialResult, observ in
                        partialResult += (observ.isConsignee == c ? 1 : 0)
                    }

            case (nil, .some(let v)):
                return observStore
                    .observations(de: eleve)
                    .reduce(into: 0) { partialResult, observ in
                        partialResult += (observ.isVerified == v ? 1 : 0)
                    }

            case (.some(let c), .some(let v)):
                return observStore
                    .observations(de: eleve)
                    .reduce(into: 0) { partialResult, observ in
                        partialResult += ((observ.isConsignee == c || observ.isVerified == v) ? 1 : 0)
                    }
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
                    .reduce(into: 0) { partialResult, colle in
                        partialResult += (colle.isConsignee == c ? 1 : 0)
                    }

            case (nil, .some(let v)):
                return colleStore
                    .colles(de: eleve)
                    .reduce(into: 0) { partialResult, colle in
                        partialResult += (colle.isVerified == v ? 1 : 0)
                    }

            case (.some(let c), .some(let v)):
                return colleStore
                    .colles(de: eleve)
                    .reduce(into: 0) { partialResult, colle in
                        partialResult += ((colle.isConsignee == c || colle.isVerified == v) ? 1 : 0)
                    }
        }
    }

    func filteredEleves(dans classe       : Classe,
                        eleveStore        : EleveStore,
                        observStore       : ObservationStore,
                        colleStore        : ColleStore,
                        filterObservation : Bool,
                        filterColle       : Bool,
                        filterFlag        : Bool,
                        searchString      : String) -> Binding<[Eleve]> {
        eleveStore.filteredEleves(dans: classe) { eleve in

            lazy var nameComplies: Bool = {
                if searchString.isNotEmpty {
                    let string = searchString.lowercased()

                    return eleve.name.familyName!.lowercased().contains(string) ||
                    eleve.name.givenName!.lowercased().contains(string)
                } else {
                    return true
                }
            }()

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

            return nameComplies &&
            ((!filterObservation && !filterColle && !filterFlag) ||
            (filterObservation && (nbObservWithActionToDo > 0)) ||
            (filterColle && nbColleWithActionToDo > 0) ||
            (filterFlag && eleve.isFlagged))

        }
    }
}
