//
//  GroupOfEleves.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 25/09/2022.
//

import Foundation

struct GroupOfEleves {
    /// Nombre de groupes formés dans la classe
    /// - Returns: Nombre de groupes formés dans la classe ou `nil`s'il n'y pas de groupe
    func numberOfGroups(dans classe : Classe,
                        eleveStore  : EleveStore) -> Int? {
        var nb: Int?
        classe.elevesID.forEach { eleveID in
            let eleve = eleveStore.item(withID: eleveID)
            if let group = eleve?.group {
                if nb == nil {
                    nb = group
                } else if group > nb! {
                    nb = group
                }
            }
        }
        return nb
    }

//    static func eleves(dans classe  : Classe) -> <#return type#> {
//        <#function body#>
//    }
}
