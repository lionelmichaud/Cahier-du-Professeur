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

    func exists(_ item: Classe) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    func exists(_ ID: UUID) -> Bool {
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
