//
//  ClassStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 18/04/2022.
//

import SwiftUI

final class ClasseStore: ObservableObject {

    // MARK: - Properties

    @Published
    var items: [Classe] = [ ]

    var nbOfItems: Int {
        items.count
    }

    // MARK: - Methods

    /// True si une classe existe déjà avec les mêmes
    /// niveaux, numéro et établissements
    /// - Parameter classe: Classe
    func exists(classe: Classe) -> Bool {
        items.contains {
            $0.isSameAs(classe)
        }
    }

    /// True si une classe existe déjà avec les mêmes
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

    /// True si une classe existe déjà avec le même ID
    /// - Parameter item: Classe
    func isPresent(_ item: Classe) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    /// True si une classe existe déjà avec le même ID
    /// - Parameter ID: ID de la Calsse
    func isPresent(_ ID: UUID) -> Bool {
        items.contains(where: { ID == $0.id})
    }

    func classe(withID ID: UUID) -> Classe? {
        items.first(where: { ID == $0.id})
    }

    func add(_ item: Classe) {
        items.insert(item, at: 0)
    }

    func deleteClasse(withID: UUID) {
        // retirer la classe de la liste
        items.removeAll {
            $0.id == withID
        }
    }

    func insert(classe         : Classe,
                `in` classesID : inout [UUID]) {
        guard classesID.isNotEmpty else {
            classesID = [classe.id]
            return
        }

        guard let index = classesID.firstIndex(where: {
            guard let c0 = self.classe(withID: $0) else {
                return false
            }
            return classe.niveau.rawValue < c0.niveau.rawValue ||
            (classe.niveau.rawValue == c0.niveau.rawValue && classe.numero < c0.numero)
        }) else {
            classesID.append(classe.id)
            return
        }
        classesID.insert(classe.id, at: index)
    }

    func heures(dans classesID : [UUID]) -> Double {
        var total = 0.0
        for c in classesID {
            total += classe(withID: c)?.heures ?? 0.0
        }
        return total
    }

    func classes(dans school: School) -> Binding<[Classe]> {
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

    static var exemple = ClasseStore()
}

extension ClasseStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}
