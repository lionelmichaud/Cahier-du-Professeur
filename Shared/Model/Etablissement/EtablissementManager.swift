//
//  SchoolManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct SchoolManager {
    func ajouter(classe : inout Classe,
                 aSchool school : inout School) {
        school.addClasse(withID: classe.id)
        classe.schoolId = school.id
    }

    func retirer(classeId            : UUID,
                 deSchoolId schoolId : UUID,
                 schools             : SchoolStore) {
        guard let schoolIndex = schools.items.firstIndex(where: { $0.id == schoolId }) else {
            return
        }
        schools.items[schoolIndex].removeClasse(withID: classeId)
    }
}
