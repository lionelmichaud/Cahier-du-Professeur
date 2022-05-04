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
        classeStore.insert(item: classe, in: &school.classesID)
        //school.addClasse(withID: classe.id)
        classe.schoolId = school.id
        classeStore.add(classe)
    }

    /// Détuire la Classe et tous ses descendants
    /// puis retirer la classe de l'établissement auquel elle appartient
    func retirer(classe          : Classe,
                 deSchool school : inout School,
                 classeStore     : ClasseStore,
                 eleveStore      : EleveStore,
                 observStore     : ObservationStore,
                 colleStore      : ColleStore) {
        // Détuire la Classe et tous ses descendants
        classeStore.deleteClasse(classe,
                                 eleveStore  : eleveStore,
                                 observStore : observStore,
                                 colleStore  : colleStore)
        // retirer la classe de l'établissement auquel elle appartient
        school.removeClasse(withID: classe.id)
    }

    /// Détuire la Classe et tous ses descendants
    /// puis retirer la classe de l'établissement auquel elle appartient
    func retirer(classeIndex     : Int,
                 deSchool school : inout School,
                 classeStore     : ClasseStore,
                 eleveStore      : EleveStore,
                 observStore     : ObservationStore,
                 colleStore      : ColleStore) {
        // Détuire la Classe et tous ses descendants
        classeStore.deleteClasse(withID      : school.classesID[classeIndex],
                                 eleveStore  : eleveStore,
                                 observStore : observStore,
                                 colleStore  : colleStore)
        // retirer la classe de l'établissement auquel elle appartient
        school.removeClasse(at: classeIndex)
    }

    func heures(dans school : School,
                classeStore : ClasseStore) -> Double {
        classeStore.heures(dans: school.classesID)
    }
}
