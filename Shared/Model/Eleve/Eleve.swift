//
//  Eleve.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Eleve: Identifiable {

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
    var sexe      : Sexe                 = .male
    var name      : PersonNameComponents = PersonNameComponents()
    var classeId  : UUID?
    var collesID  : [UUID] = [ ]
    var observsID : [UUID] = [ ]

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

    init(sexe   : Sexe,
         nom    : String,
         prenom : String) {
        self.sexe   = sexe
        self.name   = PersonNameComponents(givenName: prenom, familyName: nom)
    }

    // MARK: - Methods

    func isSameAs(_ eleve: Eleve) -> Bool {
        self.name.familyName == eleve.name.familyName &&
        self.name.givenName == eleve.name.givenName &&
        self.classeId == eleve.classeId
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

   func nbOfColles(consignee : Bool? = false,
                    verified  : Bool? = false) -> Int {
        switch (consignee, verified) {
            case (nil, nil):
                return nbOfColles

            case (.some(_), nil):
                return 1

            case (nil, .some(_)):
                return 2

            case (.some(_), .some(_)):
                return 3
        }
    }

    static let exemple = Eleve(sexe   : .male,
                               nom    : "NomDeFamille",
                               prenom : "Prénom")
}

extension Eleve: CustomStringConvertible {
    var description: String {
        """
        
        ELEVE: \(displayName)
           ID      : \(id)
           Sexe    : \(sexe.pickerString)
           Nom     : \(name.formatted(.name(style: .long)))
           ClasseID: \(String(describing: classeId))
           Observations: \(String(describing: observsID).withPrefixedSplittedLines("     "))
           Colles: \(String(describing: collesID).withPrefixedSplittedLines("     "))
        """
    }
}
