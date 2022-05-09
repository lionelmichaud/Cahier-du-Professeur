//
//  Eleve.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Eleve: Identifiable, Hashable, Codable, Ordered {

    // MARK: - Type Methods

    static func < (lhs: Eleve, rhs: Eleve) -> Bool {
        if lhs.name.familyName! != rhs.name.familyName! {
            return lhs.name.familyName! < rhs.name.familyName!
        } else {
            return lhs.name.givenName! < rhs.name.givenName!
        }
    }

    // MARK: - Properties

    var id = UUID()
    var sexe         : Sexe = .male
    var name         : PersonNameComponents = PersonNameComponents()
    var classeId     : UUID?
    var isFlagged    : Bool   = false
    var appreciation : String = ""
    var collesID     : [UUID] = [ ]
    var observsID    : [UUID] = [ ]

    var nbOfColles: Int {
        collesID.count
    }

    var nbOfObservs: Int {
        observsID.count
    }

    var displayName : String {
        name.formatted(.name(style: .long))
    }

    // MARK: - Initializers

    init(sexe      : Sexe,
         nom       : String,
         prenom    : String,
         isFlagged : Bool = false) {
        self.sexe      = sexe
        self.name      = PersonNameComponents(givenName : prenom, familyName : nom)
        self.isFlagged = isFlagged
    }

    // MARK: - Methods

    func isSameAs(_ eleve: Eleve) -> Bool {
        self.name.familyName == eleve.name.familyName &&
        self.name.givenName == eleve.name.givenName &&
        self.classeId == eleve.classeId
    }

    /// True si au moins un des deux critères est satisfait.
    ///
    /// - Parameters:
    ///   - withObservation: si `nil`on ne tient pas compte du critère
    ///   - withColle: si `nil`on ne tient pas compte du critère
    /// - Note: Si les deux critères sont `nil`, retourne true
    func satisfiesEitherOf(withObservation : Bool? = nil,
                           withColle       : Bool? = nil) -> Bool {
        switch (withObservation, withColle) {
            case (nil, nil):
                return true

            case (.some(let withObservation), nil):
                return withObservation ? observsID.isNotEmpty : observsID.isEmpty

            case (nil, .some(let withColle)):
                return withColle ? collesID.isNotEmpty : collesID.isEmpty

            case (.some(let withObservation), .some(let withColle)):
                let obs = withObservation ? observsID.isNotEmpty : observsID.isEmpty
                let col = withColle ? collesID.isNotEmpty : collesID.isEmpty
                return obs || col
        }
    }

    mutating func addObservation(withID observID: UUID) {
        observsID.insert(observID, at: 0)
    }

    mutating func removeObservation(withID observID: UUID) {
        observsID.removeAll(where: { $0 == observID })
    }

    mutating func removeObservation(at index : Int) {
        observsID.remove(at: index)
    }

    mutating func moveObservation(from indexes: IndexSet, to destination: Int) {
        observsID.move(fromOffsets: indexes, toOffset: destination)
    }

    mutating func addColle(withID colleID: UUID) {
        collesID.insert(colleID, at: 0)
    }

    mutating func removeColle(withID colleID: UUID) {
        collesID.removeAll(where: { $0 == colleID })
    }

    mutating func removeColle(at index : Int) {
        collesID.remove(at: index)
    }

    mutating func moveColle(from indexes: IndexSet, to destination: Int) {
        collesID.move(fromOffsets: indexes, toOffset: destination)
    }

    static let exemple = Eleve(sexe      : .male,
                               nom       : "NomDeFamille",
                               prenom    : "Prénom",
                               isFlagged : true)
}

extension Eleve: CustomStringConvertible {
    var description: String {
        """
        
        ELEVE: \(displayName)
           ID      : \(id)
           Sexe    : \(sexe.pickerString)
           Nom     : \(name.formatted(.name(style: .long)))
           ClasseID: \(String(describing: classeId))
           Flagged : \(isFlagged.frenchString)
           Appréciation: \(appreciation)
           Observations: \(String(describing: observsID).withPrefixedSplittedLines("     "))
           Colles: \(String(describing: collesID).withPrefixedSplittedLines("     "))
        """
    }
}
