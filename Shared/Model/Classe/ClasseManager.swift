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

    func retirer(eleveId             : UUID,
                 deClasseId classeId : UUID,
                 classeStore         : ClasseStore) {
        guard let classeIndex = classeStore.items.firstIndex(where: { $0.id == classeId }) else {
            return
        }
        classeStore.items[classeIndex].removeEleve(withID: eleveId)
    }

    func retirer(eleveIndex      : Int,
                 deClasse classe : inout Classe,
                 eleveStore      : EleveStore) {
        // supprimer l'élève de la liste d'élèves
        eleveStore.deleteEleve(withID: classe.elevesID[eleveIndex])
        // supprimer l'élève de la classe
        classe.removeEleve(at: eleveIndex)
    }
}
