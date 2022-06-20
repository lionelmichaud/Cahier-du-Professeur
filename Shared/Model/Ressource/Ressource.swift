//
//  Ressource.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 19/06/2022.
//

import Foundation

/// Ressources disponible en quantité limitée dans un établissement
struct Ressource: Identifiable, Hashable, Codable {

    // MARK: - Properties

    var id = UUID()
    var name      : String = ""
    var maxNumber : Int = 1

    // MARK: - Initializers

    internal init(id        : UUID = UUID(),
                  name      : String = "",
                  maxNumber : Int = 1) {
        self.id = id
        self.name = name
        self.maxNumber = maxNumber
    }
}

extension Ressource: CustomStringConvertible {
    var description: String {
        """

        Nom        : \(name)
        Quantité   : \(maxNumber)
        """
    }
}
