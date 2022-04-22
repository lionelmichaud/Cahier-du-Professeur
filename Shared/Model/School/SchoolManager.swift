//
//  SchoolManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct SchoolManager {
    func ajouter(classe         : inout Classe,
                 aSchool school : inout School,
                 classeStore    : ClasseStore) {
        classeStore.insert(classe: classe, in: &school.classesID)
        //school.addClasse(withID: classe.id)
        classe.schoolId = school.id
        classeStore.add(classe)
    }

    func retirer(classeId            : UUID,
                 deSchoolId schoolId : UUID,
                 schoolstore         : SchoolStore) {
        guard let schoolIndex = schoolstore.items.firstIndex(where: { $0.id == schoolId }) else {
            return
        }
        schoolstore.items[schoolIndex].removeClasse(withID: classeId)
    }

    func retirer(classeIndex     : Int,
                 deSchool school : inout School,
                 classeStore     : ClasseStore) {
        // supprimer la classe de la liste de classes
        classeStore.deleteClasse(withID: school.classesID[classeIndex])
        // supprimer la classe de l'établissement
        school.removeClasse(at: classeIndex)
    }

    func heures(dans school : School,
                classeStore : ClasseStore) -> Double {
        classeStore.heures(dans: school.classesID)
    }
}
