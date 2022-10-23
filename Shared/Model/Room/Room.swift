//
//  Room.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/10/2022.
//

import SwiftUI
import os
import Files

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "Room")

/// Salle de classe
struct Room: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case name
        case places
        case capacity
    }

    // MARK: - Type Properties

    static let exemple = Room(name     : "Salle",
                              capacity : 24)
    // MARK: - Properties

    var id = UUID()
    var name     : String    = ""
    var places   : [CGPoint] = []
    var image    : Image? // cache
    var capacity : Int {
        willSet(newCapacity) {
            if newCapacity < places.count {
                places = places.dropLast(places.count - newCapacity)
            }
        }
    }

    // MARK: - Computed Properties

    /// Nombre de places positionnées sur la le plan de la salle de classe
    var nbPlacesDefined: Int {
        places.count
    }

    /// Nombre de places non encore positionnées sur la le plan de la salle de classe
    var nbPlacesUndefined: Int {
        capacity - places.count
    }

    /// URL du fichier image PNG contenant le plan de la salle de classe
   var planURL: URL? {
        let planName = "Plan " + name + ".png"

        // vérifier l'existence du Folder Document
        guard let documentsFolder = Folder.documents else {
            let error = FileError.failedToResolveDocuments
            customLog.log(level: .fault,
                          "\(error.rawValue))")
            return nil
        }

        let planURL = documentsFolder.url.appendingPathComponent(planName)

        return planURL
    }

    // MARK: - Initializers

    init(id       : UUID   = UUID(),
         name     : String = "",
         capacity : Int    = 24) {
        self.id       = id
        self.name     = name
        self.capacity = capacity
    }
}

extension Room: CustomStringConvertible {
    var description: String {
        """

        Nom : \(name)
        Capacité de la salle : \(capacity)
        """
    }
}
