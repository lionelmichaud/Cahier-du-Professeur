//
//  ClassManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct ClasseManager {
    func ajouter(eleve          : inout Eleve,
                 aClasse classe : inout Classe,
                 eleveStore     : EleveStore) {
        eleveStore.insert(eleve: eleve, in: &classe.elevesID)
        eleve.classeId = classe.id
        eleveStore.add(eleve)
    }

    func retirer(eleve           : Eleve,
                 deClasse classe : inout Classe,
                 eleveStore      : EleveStore,
                 observStore     : ObservationStore,
                 colleStore      : ColleStore) {
        // Détruire l'élève et tous ses descendants
        eleveStore.deleteEleve(eleve,
                               observStore : observStore,
                               colleStore  : colleStore)
        // retirer l'élève de la classe à laquelle il appartient
        classe.removeEleve(withID: eleve.id)
    }

    /// Détruire l'élève et tous ses descendants
    /// puis retirer l'élève de la classe à laquelle il appartient
    func retirer(eleveIndex      : Int,
                 deClasse classe : inout Classe,
                 eleveStore      : EleveStore,
                 observStore     : ObservationStore,
                 colleStore      : ColleStore) {
        // Détruire l'élève et tous ses descendants
        eleveStore.deleteEleve(withID      : classe.elevesID[eleveIndex],
                               observStore : observStore,
                               colleStore  : colleStore)
        // retirer l'élève de la classe à laquelle il appartient
        classe.removeEleve(at: eleveIndex)
    }

    // MARK: - Getters

    func nbOfObservations(de classe    : Classe,
                          isConsignee  : Bool? = nil,
                          isVerified   : Bool? = nil,
                          eleveStore   : EleveStore,
                          observStore  : ObservationStore) -> Int {
        switch (isConsignee, isVerified) {
            case (nil, nil):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          observStore : observStore)
                }
                return total

            case (.some(let c), nil):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          isConsignee : c,
                                          observStore : observStore)
                }
                return total

            case (nil, .some(let v)):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          isVerified  : v,
                                          observStore : observStore)
                }
                return total

            case (.some(let c), .some(let v)):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          isConsignee : c,
                                          isVerified  : v,
                                          observStore : observStore)
                }
                return total
        }
    }

    func nbOfColles(de classe   : Classe,
                    isConsignee : Bool?  = nil,
                    isVerified  : Bool?  = nil,
                    eleveStore  : EleveStore,
                    colleStore  : ColleStore) -> Int {
        switch (isConsignee, isVerified) {
            case (nil, nil):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de         : eleve,
                                    colleStore : colleStore)
                }
                return total

            case (.some(let c), nil):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de          : eleve,
                                    isConsignee : c,
                                    colleStore  : colleStore)
                }
                return total

            case (nil, .some(let v)):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de         : eleve,
                                    isVerified : v,
                                    colleStore : colleStore)
                }
                return total

            case (.some(let c), .some(let v)):
                let eleves = eleveStore.eleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de          : eleve,
                                    isConsignee : c,
                                    isVerified  : v,
                                    colleStore  : colleStore)
                }
                return total
        }
    }
}
