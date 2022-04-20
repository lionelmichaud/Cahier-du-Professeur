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

    func delete(_ item  : Classe,
                schools : SchoolStore) {
        // supprimer tous les élèves de la classe
        //        item.eleves.forEach { eleve in
        //            eleves.delete(eleve,
        //                          observs: observs,
        //                          colles: colles)
        //        }

        // zeroize du pointeur de l'établissement vers la classe
        if let schoolId = item.schoolId {
            let schoolManager = SchoolManager()
            schoolManager.retirer(classeId   : item.id,
                                  deSchoolId : schoolId,
                                  schools    : schools)
        }

        // retirer la classe de la liste
        items.removeAll {
            $0.id == item.id
        }
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
