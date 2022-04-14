//
//  Eleve.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

class Eleve: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var sexe   : Sexe = .male
    @Published
    var name   : PersonNameComponents = PersonNameComponents()
    @Published
    var classe : Classe?

    var displayName : String {
        "\(sexe.displayString) \(name.formatted(.name(style: .long)))"
    }

    init(sexe   : Sexe,
         nom    : String,
         prenom : String,
         classe : Classe?  = nil) {
        self.sexe   = sexe
        self.name   = PersonNameComponents(givenName: prenom, middleName: nom)
        self.classe = classe
    }

    static let exemple = Eleve(sexe   : .male,
                               nom    : "Nom",
                               prenom : "Prénom",
                               classe : Classe.exemple)
}

extension Eleve: CustomStringConvertible {
    var description: String {
        """
        
        ELEVE: \(displayName)
           Sexe: \(sexe.pickerString)
           Nom: \(name.formatted(.name(style: .long)))
           Classe: \(classe?.displayString ?? "inconnue")
        """
    }
}
