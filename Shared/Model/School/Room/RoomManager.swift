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

    /// Si un élève de la `classe` est assis à la place `seatID` alors il est retiré de cette place.
    /// - Parameters:
    ///   - seatID: Identifiant de la place de la salle de classe
    ///   - classe: classe considérée
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

    /// Retourne la liste des classes de `school` qui utilisent la salle de classe d'identifiant `roomID`.
    static func classesUsing(roomID      : UUID,
                             dans school : School,
                             classeStore : ClasseStore) -> [Classe] {
        school.classesID.compactMap { classeID in
            guard let classe = classeStore.item(withID: classeID) else {
                return nil
            }
            if classe.roomId == roomID {
                return classe
            } else {
                return nil
            }
        }
    }

    /// Supprime le plan de salle de classe `room` de l'établissement `school`.
    ///
    /// Supprimera tous les sièges positionnés sur le plan de la salle de classe `room`.
    ///
    /// Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
    /// - Parameters:
    ///   - room: Salle de classe dont il faut supprimer le plan.
    ///   - school: Etablissement auquel appartient la salle de classe.
    static func deleteRoomPlan(de room: inout Room,
                               dans school : School,
                               classeStore : ClasseStore,
                               eleveStore  : EleveStore) {
        // Supprimer tous les sièges positionnés sur le plan de la salle de classe.
        // Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
        room.removeAllSeatsFromPlan(
            dans: school,
            classStore: classeStore,
            eleveStore: eleveStore
        )

        // Supprimer le lien entre les classe et cette salle de classe
        var classes = RoomManager.classesUsing(
            roomID: room.id,
            dans: school,
            classeStore: classeStore
        )
        for idx in classes.indices {
            classes[idx].roomId = nil
        }
        classeStore.update(with: classes)

        // Supprimer l'image du plan de la salle de classe
        try? PersistenceManager().deleteFile(withURL: room.planURL)
    }
}
