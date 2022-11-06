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
    /// Nom de la salle de classe
    var name     : String = ""
    /// Plan de la salle de classe
    var image    : Image? // cache
    /// Places déjà positionnées sur le plan
    private var seats: [Seat] = []
    private (set) var capacity: Int

    // MARK: - Computed Properties

    /// Nombre de places positionnées sur la le plan de la salle de classe
    var nbSeatPositionned: Int {
        seats.count
    }

    /// Nombre de places non encore positionnées sur la le plan de la salle de classe
    var nbSeatUnpositionned: Int {
        capacity - seats.count
    }

    var fileName: String {
        "Plan " + name + ".png"
    }

    /// URL du fichier image PNG contenant le plan de la salle de classe
    var planURL: URL {
        URL.documentsDirectory
            .appending(path: fileName)
    }

    var planExists: Bool {
        CGImageSourceCreateWithURL(planURL as CFURL, nil) != nil
    }

    /// Retourne les dimensions de l'image
    var imageSize : CGSize? {
        if let imageSource = CGImageSourceCreateWithURL(planURL as CFURL, nil),
           let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            let pixelWidth  = imageProperties[kCGImagePropertyPixelWidth] as! Int
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
            //print("Width: \(pixelWidth), Height: \(pixelHeight)")
            return CGSize(width: pixelWidth, height: pixelHeight)
        }
        return nil
    }

    // MARK: - Subscript

    subscript(seatIndex idx: Int) -> Seat {
        get {
            return seats[idx]
        }
        set(newValue) {
            seats[idx] = newValue
        }
    }
    // MARK: - Initializers

    init(id       : UUID   = UUID(),
         name     : String = "",
         capacity : Int    = 24) {
        self.id       = id
        self.name     = name
        self.capacity = capacity
    }

    // MARK: - Methods

    /// Positionner un siège supplémentaires `seat` sur le plan de la salle de classe.
    /// - Parameter seat: Le siège à ajouter.
    ///
    /// Si le nombre de place déjà positionnées est égale à la capacité max de la salle de classe,
    /// alors ne fait rien.
    mutating func addSeatToPlan(_ seat: Seat) {
        guard nbSeatUnpositionned.isPositive else {
            return
        }
        seats.append(seat)
    }

    /// Supprimer le siège `seatIndex` positionnés sur le plan de la salle de classe
    /// Le siège sera libérés des élèves assis dessus dans l'ensemble des classes.
    /// - Parameters:
    ///   - seatIndex: Indice de la place à supprimer du plan
    ///   - school: Etablissement dans lequel la salle de classe se trouve
    mutating func removeSeatFromPlan(seatIndex   : Int,
                                     dans school : School,
                                     classStore  : ClasseStore,
                                     eleveStore  : EleveStore) {
        guard seats.indices.contains(seatIndex) else {
            return
        }
        school.classesID.forEach { classeID in
            // pour chaque classe dans l'étabissement
            if let classe = classStore.item(withID: classeID) {
                RoomManager
                    .removeEleveFromSeat(seatID     : seats[seatIndex].id,
                                         dans       : classe,
                                         eleveStore : eleveStore)
            }
        }
        seats.remove(at: seatIndex)
    }

    /// Supprimer tous les sièges positionnés sur le plan de la salle de classe.
    /// Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
    /// - Parameters:
    ///   - school: Etablissement dans lequel la salle de classe se trouve
    mutating func removeAllSeatsFromPlan(dans school : School,
                                         classStore  : ClasseStore,
                                         eleveStore  : EleveStore) {
        if seats.isNotEmpty {
            for idxSeat in seats.indices {
                // pour chaque place à retirer
                school.classesID.forEach { classeID in
                    // pour chaque classe dans l'étabissement
                    if let classe = classStore.item(withID: classeID) {
                        RoomManager
                            .removeEleveFromSeat(seatID     : seats[idxSeat].id,
                                                 dans       : classe,
                                                 eleveStore : eleveStore)
                    }
                }
            }
            seats = []
        }
    }

    /// Retirer tous les éléves de la `classe` des sièges de la salle de classe.
    func removeAllSeatedEleve(dans classe : Classe,
                              eleveStore  : EleveStore) {
        if seats.isNotEmpty {
            for idxSeat in seats.indices {
                // pour chaque place à retirer
                RoomManager
                    .removeEleveFromSeat(seatID     : seats[idxSeat].id,
                                         dans       : classe,
                                         eleveStore : eleveStore)
            }
        }
    }

    /// Augmenter la capacité de la salle de classe
    /// - Parameter increment: Nobre de places à ajouter
    ///
    /// Si `increment`est ≤ 0, alors ne fait rien
    mutating func incrementCapacity(increment: Int = 1) {
        guard increment.isPositive else {
            return
        }
        capacity += increment
    }

    /// Réduire la capacité de la salle de classe
    /// - Parameter decrement: Nobre de places à supprimer (>0)
    ///
    /// Si `decrement`est ≤ 0, alors ne fait rien
    mutating func decrementCapacity(decrement   : Int = 1,
                                    dans school : School,
                                    classStore  : ClasseStore,
                                    eleveStore  : EleveStore) {
        guard decrement.isPositive else {
            return
        }
        setCapacity(newCapacity : capacity - decrement,
                    dans        : school,
                    classStore  : classStore,
                    eleveStore  : eleveStore)
    }

    mutating func setCapacity(newCapacity : Int,
                              dans school : School,
                              classStore  : ClasseStore,
                              eleveStore  : EleveStore) {
        if newCapacity < seats.count {
            for idxSeat in newCapacity ... (seats.count - 1) {
                // pour chaque place à retirer
                school.classesID.forEach { classeID in
                    // pour chaque classe dans l'étabissement
                    if let classe = classStore.item(withID: classeID) {
                        RoomManager
                            .removeEleveFromSeat(seatID     : seats[idxSeat].id,
                                                 dans       : classe,
                                                 eleveStore : eleveStore)
                    }
                }
            }
            seats = seats.dropLast(seats.count - newCapacity)
        }
        capacity = newCapacity
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
