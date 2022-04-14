//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

class Classe: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var etablissement: Etablissement?
    @Published
    var niveau: NiveauClasse = .n6ieme
    @Published
    var numero: Int = 1
    @Published
    var eleves: [Eleve] = []

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

    static let exemple = Classe(etablissement : Etablissement.exemple,
                                niveau        : .n6ieme,
                                numero        : 1)

}

extension Classe: CustomStringConvertible {
    var description: String {
        """
        
        CLASSE: \(displayString)
           Niveau: \(niveau.displayString)
           Numéro: \(numero)
           Etablissement: \(etablissement?.displayString ?? "inconnu")
        """
    }
}
