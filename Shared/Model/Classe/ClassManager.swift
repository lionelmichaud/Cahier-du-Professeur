//
//  ClassManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct ClassManager {
    static func ajouter(eleve          : Eleve,
                        aClasse classe : Classe) {
        classe.eleves.append(eleve)
        eleve.classe = classe
    }

    static func supprimer(eleve           : Eleve,
                          deClasse classe : Classe) {
        classe.eleves.removeAll { $0.id == eleve.id }
        eleve.classe = nil
    }
}
