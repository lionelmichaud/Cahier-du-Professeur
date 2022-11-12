//
//  Seat.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 29/10/2022.
//

import Foundation

/// Place assise dans une salle de classe
struct Seat: Identifiable, Codable, Hashable {

    // MARK: - Type Properties

    static let exemple = Seat()

    // MARK: - Properties

    var id = UUID()
    /// Posiion de la place assise à l'intérieur de la classe en % [0.0, 1.0]
    var locInRoom: CGPoint

    // MARK: - Initilizers

    init(id        : UUID    = UUID(),
         locInRoom : CGPoint = CGPoint(x : 0.5, y : 0.5)) {
        self.id        = id
        self.locInRoom = locInRoom
    }

    init(id : UUID   = UUID(),
         x  : Double = 0.5,
         y  : Double = 0.5) {
        self.id        = id
        self.locInRoom = CGPoint(x: x, y: y)
    }
}

extension Seat: CustomStringConvertible {
    var description: String {
        """

        PLACE ASSISE : \(id)
        """
    }
}
