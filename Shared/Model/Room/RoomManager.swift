//
//  RoomManager.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import Foundation

struct RoomManager {
    static func room(withId roomID : UUID,
                     in school : School) -> Room? {
        school.rooms.first { room in
            room.id == roomID
        }
    }
}
