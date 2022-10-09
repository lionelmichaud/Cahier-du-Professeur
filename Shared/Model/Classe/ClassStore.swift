//
//  ClassStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 18/04/2022.
//

import SwiftUI

typealias ClasseStore = JsonCodableArray<Classe>

extension ClasseStore {

    // MARK: - Methods

    /// True si une classe existe déjà dans le strore avec les mêmes
    /// niveaux, numéro et établissements
    /// - Parameter classe: Classe
    func exists(_ classe: Classe) -> Bool {
        items.contains {
            $0.isSameAs(classe)
        }
    }

    /// True si une classe existe déjà dans l'établissement avec les mêmes
    /// niveaux, numéro et établissements
    /// - Parameter classe: Classe
    /// - Parameter schoolID: ID de l'établissement
    func exists(classe       : Classe,
                `in`schoolID : UUID) -> Bool {
        var c = classe
        c.schoolId = schoolID
        return items.contains {
            $0.isSameAs(c)
        }
    }

    func deleteClasse(_ classe    : Classe,
                      eleveStore  : EleveStore,
                      observStore : ObservationStore,
                      colleStore  : ColleStore) {
        deleteClasse(withID      : classe.id,
                     eleveStore  : eleveStore,
                     observStore : observStore,
                     colleStore  : colleStore)
    }

    func deleteClasse(withID id   : UUID,
                      eleveStore  : EleveStore,
                      observStore : ObservationStore,
                      colleStore  : ColleStore) {
        guard let classe = item(withID: id) else {
            return
        }
        // supprimer toutes les élèves de la classe
        classe.elevesID.forEach { eleveID in
            eleveStore.deleteEleve(withID      : eleveID,
                                   observStore : observStore,
                                   colleStore  : colleStore)
        }
        // retirer la classe de la liste
        items.removeAll {
            $0.id == classe.id
        }
        saveAsJSON()
    }

    func heures(dans classesID : [UUID]) -> Double {
        var total = 0.0
        for c in classesID {
            total += item(withID: c)?.heures ?? 0.0
        }
        return total
    }

    func sortedClasses(dans school: School) -> Binding<[Classe]> {
        Binding<[Classe]>(
            get: {
                self.items
                    .filter {
                        if let schoolId = $0.schoolId {
                            return schoolId == school.id
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

    func sortedClasses(dans school: School) -> [Classe] {
        self.items
            .filter {
                if let schoolId = $0.schoolId {
                    return schoolId == school.id
                } else {
                    return false
                }
            }
            .sorted(by: <)
    }

    func filteredClasses(dans school: School,
                         _ isIncluded: @escaping (Classe) -> Bool) -> Binding<[Classe]> {
        Binding<[Classe]>(
            get: {
                self.items
                    .filter { classe in
                        if let schoolId = classe.schoolId {
                            return (schoolId == school.id) && isIncluded(classe)
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
}
