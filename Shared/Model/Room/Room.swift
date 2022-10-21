//
//  Room.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/10/2022.
//

import Foundation

/// Salle de classe
struct Room: Identifiable, Hashable, Codable {

    // MARK: - Type Properties

    static let exemple = Room(name             : "Salle",
                              maxNumberOfEleve : 2)
    // MARK: - Properties

    var id = UUID()
    var name             : String = ""
    var maxNumberOfEleve : Int    = 1

    // MARK: - Initializers

    internal init(id               : UUID   = UUID(),
                  name             : String = "",
                  maxNumberOfEleve : Int    = 1) {
        self.id = id
        self.name = name
        self.maxNumberOfEleve = maxNumberOfEleve
    }
}

extension Room: CustomStringConvertible {
    var description: String {
        """

        Nom : \(name)
        Nombre maxi d'élèves : \(maxNumberOfEleve)
        """
    }
}
