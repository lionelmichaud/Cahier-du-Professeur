//
//  Etablissement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct Etablissement: Identifiable {
    var id = UUID()
    var niveau  : NiveauEtablissement = .college
    var nom     : String              = ""
    var classes : [Classe]            = []

    var nbOfClasses: Int {
        classes.count
    }

    var displayString: String {
        "\(niveau.displayString) \(nom)"
    }

    init(niveau : NiveauEtablissement = .college,
         nom    : String = "") {
        self.niveau = niveau
        self.nom = nom
    }

    static var exemple = Etablissement(niveau: .college, nom: "Galilée")
}

extension Etablissement: CustomStringConvertible {
    var description: String {
        """
        
        ETABLISSEMENT: \(displayString)
           Niveau: \(niveau.displayString)
           Nom: \(nom)
           Classes: \(String(describing: classes).withPrefixedSplittedLines("     "))
        """
    }
}
