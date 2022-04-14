//
//  ColleManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct ColleManager {
    func ajouter(colle : Colle,
                 aEleve eleve : Eleve) {
        eleve.colles.insert(colle, at: 0)
        colle.eleve = eleve
    }

    func retirer(colle : Colle,
                 deEleve eleve : Eleve) {
        eleve.colles.removeAll { $0.id == colle.id }
        colle.eleve = nil
    }
}
