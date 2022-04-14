//
//  EtablissementManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct EtablissementManager {
    static func ajouter(classe : Classe,
                        aEtablissement etablissement : Etablissement) {
        etablissement.classes.append(classe)
        classe.etablissement = etablissement
    }

    static func supprimer(classe : Classe,
                          deEtablissement etablissement : Etablissement) {
        etablissement.classes.removeAll { $0.id == classe.id }
        classe.etablissement = nil
    }
}
