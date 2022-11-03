//
//  RoomManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI

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
                               eleveStore  : EleveStore) -> [Binding<Eleve>] {
        guard classe.roomId != nil else { return [] }

        return classe.elevesID.compactMap { eleveID in
            if let eleve = eleveStore.itemBinding(withID: eleveID),
               eleve.wrappedValue.seatId == nil {
                return eleve
            } else {
                return nil
            }
        }
    }

    /// Retourne le premier élève de la `classe` assis à la place `seatID`.
    /// - Parameters:
    ///   - seatID: Identifiant de la place de la salle de classe.
    /// - Returns: Premier élève de la `classe` assis à la place `seatID`.
    ///             Retourne `nil` si aucun élève n'est assis à cette place.
    static func eleveOnSeat(seatID      : UUID,
                            dans classe : Classe,
                            eleveStore  : EleveStore) -> Binding<Eleve>? {

        guard classe.roomId != nil else { return nil }

        return classe.elevesID.compactMap { eleveID in
            if let eleve = eleveStore.itemBinding(withID: eleveID),
               eleve.wrappedValue.seatId == seatID {
                return eleve
            } else {
                return nil
            }
        }.first
    }

    static func removeEleveFromSeat(seatID      : UUID,
                                    dans classe : Classe,
                                    eleveStore  : EleveStore) {
        if let eleveOnSeat = eleveOnSeat(
            seatID     : seatID,
            dans       : classe,
            eleveStore : eleveStore
        ) {
            // enlever l'élève qui était assis à cette place
            eleveOnSeat.wrappedValue.seatId = nil
        }
    }
}
