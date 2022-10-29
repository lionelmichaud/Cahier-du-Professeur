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

/// Salle de classe dans un établissement
struct Room: Identifiable, Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case seats
        case capacity
    }

    // MARK: - Type Properties

    static let exemple = Room(name     : "Salle",
                              capacity : 24)
    // MARK: - Properties

    var id = UUID()
    var name     : String = ""
    var seats    : [Seat] = []
    var image    : Image? // cache
    var capacity : Int {
        willSet(newCapacity) {
            if newCapacity < seats.count {
                seats = seats.dropLast(seats.count - newCapacity)
            }
        }
    }

    // MARK: - Computed Properties

    /// Nombre de places positionnées sur la le plan de la salle de classe
    var nbPlacesDefined: Int {
        seats.count
    }

    /// Nombre de places non encore positionnées sur la le plan de la salle de classe
    var nbPlacesUndefined: Int {
        capacity - seats.count
    }

    /// URL du fichier image PNG contenant le plan de la salle de classe
   var planURL: URL? {
        let planName = "Plan " + name + ".png"

       return URL.documentsDirectory
           .appending(path: planName)
   }

    /// Retourne les dimensions de l'image
    var imageSize : CGSize? {
        if let planURL,
           let imageSource = CGImageSourceCreateWithURL(planURL as CFURL, nil),
           let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            let pixelWidth  = imageProperties[kCGImagePropertyPixelWidth] as! Int
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
            //print("Width: \(pixelWidth), Height: \(pixelHeight)")
            return CGSize(width: pixelWidth, height: pixelHeight)
        }
        return nil
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

        Salle de classe : \(name)
        Capacité de la salle : \(capacity)
        """
    }
}
