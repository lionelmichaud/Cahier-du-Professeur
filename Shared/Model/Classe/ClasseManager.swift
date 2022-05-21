//
//  ClassManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

/// Gestion des classes et de leurs liens avec leurs dépendants (établissements, élèves...)
struct ClasseManager {

    /// Ajouter un `eleve`à une `classe` et à la liste des élève du store `eleveStore`
    /// - Parameters:
    ///   - eleve: nouvel élève dans la `classe`
    ///   - classe: classe à lauqlelle ajouter le nouvel `eleve`
    ///   - eleveStore: store des élèves
    func ajouter(eleve          : inout Eleve,
                 aClasse classe : inout Classe,
                 eleveStore     : EleveStore) {
        eleveStore.insert(item: eleve, in: &classe.elevesID)
        eleve.classeId = classe.id
        eleveStore.add(eleve)
    }

    /// Détruire l'`eleve` de la liste du store des élèves `eleveStore`
    /// ainsi que tous ses descendants (observ, colles...) des listes `observStore`et `colleStore`
    /// puis retirer l'élève de la `classe` à laquelle il appartient
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

    func retirerTousLesEleves(deClasse classe : inout Classe,
                              eleveStore      : EleveStore,
                              observStore     : ObservationStore,
                              colleStore      : ColleStore) {
        let eleves = EleveManager()
            .filteredEleves(dans              : classe,
                                  eleveStore        : eleveStore,
                                  observStore       : observStore,
                                  colleStore        : colleStore,
                                  filterObservation : false,
                                  filterColle       : false,
                                  filterFlag        : false,
                                  searchString      : "")
        eleves.wrappedValue.forEach { eleve in
            self.retirer(eleve       : eleve,
                         deClasse    : &classe,
                         eleveStore  : eleveStore,
                         observStore : observStore,
                         colleStore  : colleStore)
        }
    }

    /// Détruire l'élève à la position `eleveIndex`de la liste du store des élèves `eleveStore`
    /// ainsi que tous ses descendants (observ, colles...) des listes `observStore`et `colleStore`
    /// puis retirer l'élève de la `classe` à laquelle il appartient
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
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          observStore : observStore)
                }
                return total

            case (.some(let c), nil):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          isConsignee : c,
                                          observStore : observStore)
                }
                return total

            case (nil, .some(let v)):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfObservations(de          : eleve,
                                          isVerified  : v,
                                          observStore : observStore)
                }
                return total

            case (.some(let c), .some(let v)):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
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
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de         : eleve,
                                    colleStore : colleStore)
                }
                return total

            case (.some(let c), nil):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de          : eleve,
                                    isConsignee : c,
                                    colleStore  : colleStore)
                }
                return total

            case (nil, .some(let v)):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
                var total = 0
                eleves.forEach { eleve in
                    total += EleveManager()
                        .nbOfColles(de         : eleve,
                                    isVerified : v,
                                    colleStore : colleStore)
                }
                return total

            case (.some(let c), .some(let v)):
                let eleves = eleveStore.filteredEleves(dans: classe).wrappedValue
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
