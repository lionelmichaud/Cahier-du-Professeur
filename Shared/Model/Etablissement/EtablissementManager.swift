//
//  EtablissementManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct EtablissementManager {
    func ajouter(classe : inout Classe,
                 aEtablissement etablissement : inout Etablissement) {
        etablissement.classes.insert(classe, at: 0)
        classe.etablissement = etablissement
    }

    func retirer(classe : inout Classe,
                 deEtablissement etablissement : inout Etablissement) {
        etablissement.classes.removeAll { $0.id == classe.id }
        classe.etablissement = nil
    }
}
