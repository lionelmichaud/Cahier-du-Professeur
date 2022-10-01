//
//  GroupManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 27/09/2022.
//

import SwiftUI

struct GroupManager {
    /// Retourne le groupe de la `classe` contenant l'élève de nom `eleveName`
    /// - Returns: Groupe contenant l'élève de nom `eleveName` ou tableau vide si l'élève n'est pas trouvé
    static func groups(dans classe         : Classe,
                       including eleveName : String,
                       eleveStore          : EleveStore) -> [GroupOfEleves] {
        if eleveName.isEmpty {
            return groups(dans       : classe,
                          eleveStore : eleveStore)

        } else {
            let string = eleveName.lowercased()
            var groupNum: Int?

            // dans quel groupe se trouve l'élève ?
            classe.elevesID.forEach { eleveID in
                if let eleve = eleveStore.item(withID: eleveID) {
                    if eleve.name.familyName!.lowercased().contains(string) ||
                        eleve.name.givenName!.lowercased().contains(string) {
                        groupNum = eleve.group
                    }
                }
            }
            guard let groupNum else {
                return [ ]
            }

            // ajouter tous les élèves du même groupe au groupe
            var group = GroupOfEleves(number: groupNum)
            classe.elevesID.forEach { eleveID in
                if let eleve = eleveStore.item(withID: eleveID) {
                    if eleve.group == groupNum {
                        group.elevesID.append(eleveID)
                    }
                }
            }
            return [group]
        }
    }

    /// Retourne les groupes constitués dans la classe
    /// - Returns: Les groupes constitués dans la classe
    static func groups(dans classe : Classe,
                       eleveStore  : EleveStore) -> [GroupOfEleves] {
        // initiliser une liste de groupes vides
        var groups = [GroupOfEleves]()
        let largestGroupNumber = largestGroupNumber(dans       : classe,
                                                    eleveStore : eleveStore)
        guard largestGroupNumber > 0 else {
            return groups
        }

        for idx in 1 ... largestGroupNumber {
            groups.append(GroupOfEleves(number: idx))
        }

        // remplir les groupes avec des élèves
        classe.elevesID.forEach { eleveID in
            let eleve = eleveStore.item(withID: eleveID)
            if let groupNum = eleve?.group {
                groups[groupNum - 1].elevesID.append(eleveID)
            }
        }

        return groups
    }

    /// Plus grand numéro de groupe dans la classe
    static func largestGroupNumber(dans classe : Classe,
                                   eleveStore  : EleveStore) -> Int {
        var nb: Int = 0
        classe.elevesID.forEach { eleveID in
            let eleve = eleveStore.item(withID: eleveID)
            if let group = eleve?.group {
                if group > nb {
                    nb = group
                }
            }
        }
        return nb
    }

    /// Former les groupes par ordre alphabétique dans une classe
    /// - Parameters:
    ///   - nbEleveParGroupe: nombre d'élève idéal par groupe
    ///   - classe: dans cette classe
    static func formOrderedGroups(nbEleveParGroupe : Int,
                                  dans classe      : Classe,
                                  eleveStore       : EleveStore) {
        func formRegularGroups(_ nb: Int) {
            for idx in eleves.indices {
                let (q, _) = idx.quotientAndRemainder(dividingBy: nbEleveParGroupe)
                eleves[idx].wrappedValue.group = q + 1
            }
        }

        let eleves: Binding<[Eleve]> = eleveStore.filteredEleves(dans: classe)
        let nbEleves = eleves.count
        let (nbGroupes, reste) = nbEleves.quotientAndRemainder(dividingBy: nbEleveParGroupe)
        let distributeRemainder = reste > 0 && (reste.double() < nbEleveParGroupe.double() / 2.0)

        if reste == 0 {
            // nombre entier de groupes complets
            formRegularGroups(nbGroupes)

        } else if distributeRemainder {
            // les élèves formant un groupe incomplet sont redistribués sur les derniers groupes complets
            let nbOfRegularGroups = nbGroupes - reste
            let firstRemainEleveIndex = nbOfRegularGroups * nbEleveParGroupe
            formRegularGroups(nbGroupes)
            for group in nbOfRegularGroups + 1 ... nbOfRegularGroups + reste {
                for i in 0 ... nbEleveParGroupe {
                    eleves[firstRemainEleveIndex + i * (group - nbOfRegularGroups)].wrappedValue.group = group
                }
            }

        } else {
            // le dernier groupe est laissé incomplet
            formRegularGroups(nbGroupes)
            for idx in (eleves.endIndex-reste) ... eleves.endIndex-1 {
                eleves[idx].wrappedValue.group = nbGroupes + 1
            }
        }
        eleves.forEach { eleve in
            print(eleve.wrappedValue.displayName(.nomPrenom) + String(describing: eleve.group))
        }
    }

    /// Former les groupes aléatoirement dans une classe
    /// - Parameters:
    ///   - nbEleveParGroupe: nombre d'élève idéal par groupe
    ///   - classe: dans cette classe
    static func formRandomGroups(nbEleveParGroupe : Int,
                                 dans classe      : Classe,
                                 eleveStore       : EleveStore) {

    }

    /// Dissoudre les groupes formés dans une classe
    /// - Parameters:
    ///   - classe: dans cette classe
    static func disolveGroups(dans classe : Classe,
                              eleveStore  : EleveStore) {
        let eleves: Binding<[Eleve]> = eleveStore.filteredEleves(dans: classe)
        for idx in eleves.indices {
            eleves[idx].wrappedValue.group = nil
        }
    }
}
