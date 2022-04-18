//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Classe: Identifiable {
    var id = UUID()
    var etablissement: Etablissement?
    var niveau: NiveauClasse = .n6ieme
    var numero: Int = 1
    var eleves: [Eleve] = []

    var nbOfEleves: Int {
        eleves.count
    }

    var displayString: String {
        "\(niveau.displayString)\(numero)"
    }

    internal init(etablissement : Etablissement? = nil,
                  niveau        : NiveauClasse,
                  numero        : Int) {
        self.etablissement = etablissement
        self.niveau        = niveau
        self.numero        = numero
    }

    static let exemple = Classe(niveau : .n6ieme,
                                numero : 1)

}

extension Classe: CustomStringConvertible {
    var description: String {
        """
        
        CLASSE: \(displayString)
           Niveau: \(niveau.displayString)
           Numéro: \(numero)
           Etablissement: \(etablissement?.displayString ?? "inconnu")
           Eleves: \(String(describing: eleves).withPrefixedSplittedLines("     "))
        """
    }
}
