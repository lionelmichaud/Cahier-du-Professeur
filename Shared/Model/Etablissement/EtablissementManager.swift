//
//  EtablissementManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct EtablissementManager {
    func ajouter(classe : Classe,
                 aEtablissement etablissement : Etablissement) {
        etablissement.classes.insert(classe, at: 0)
        classe.etablissement = etablissement
    }

    func retirer(classe : Classe,
                 deEtablissement etablissement : Etablissement) {
        etablissement.classes.removeAll { $0.id == classe.id }
        classe.etablissement = nil
    }
}
