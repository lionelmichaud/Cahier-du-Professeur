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
        "\(sexe.displayString) \(name.formatted(.name(style: .long)))"
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
        self.name.givenName == eleve.name.givenName
    }

    static let exemple = Eleve(sexe   : .male,
                               nom    : "Nom",
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
