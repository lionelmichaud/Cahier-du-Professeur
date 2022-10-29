//
//  RoomManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import Foundation

struct RoomManager {

    /// Retourne la salle de classe de l'établissement `school`
    /// dont l'identifiant est `roomID`.
    /// - Parameters:
    ///   - roomID: identifiant de la salle de classe recherchée
    ///   - school: établissement dans lequel on recherche la salle de classe
    /// - Returns: salle de classe
    static func room(withId roomID : UUID,
                     in school     : School) -> Room? {
        school.rooms.first { room in
            room.id == roomID
        }
    }

    /// Retourne un tableau des élèves de la `classe`qui n'ont pas de place affectée
    /// dans leur salle de classe.
    ///
    /// La liste sera vide si la classe n'a pas de salle de classe définie.
    /// - Returns: Liste des élèves sans place affectée dans leur salle de classe
    static func unSeatedEleves(dans classe : Classe,
                               eleveStore  : EleveStore) -> [Eleve.ID] {
        classe.elevesID.compactMap { eleveID in
            if let eleve = eleveStore.item(withID: eleveID),
               classe.roomId != nil,
               eleve.seatId == nil {
                return eleve.id
            } else {
                return nil
            }
        }
    }
}
