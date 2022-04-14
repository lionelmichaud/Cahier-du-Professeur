//
//  Etablissement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

class Etablissement: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var niveau: NiveauEtablissement = .college
    @Published
    var nom: String = ""
    @Published
    var classes : [Classe] = []

    var displayString: String {
        "\(niveau.displayString) \(nom)"
    }

    internal init(niveau: NiveauEtablissement,
                  nom: String) {
        self.niveau = niveau
        self.nom = nom
    }

    static let exemple = Etablissement(niveau: .college, nom: "Galilée")
}

extension Etablissement: CustomStringConvertible {
    var description: String {
        """
        
        ETABLISSEMENT: \(displayString)
           Niveau: \(niveau.displayString)
           Nom: \(nom)
           Classe: \(classes.description)
        """
    }
}
