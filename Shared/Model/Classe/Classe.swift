//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class ClasseStore: ObservableObject {
    @Published
    var items: [Classe] = [ ]
    var nbOfItems: Int {
        items.count
    }

    func exists(_ item: Classe) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    func add(_ item: Classe) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : Classe,
                eleves  : EleveStore,
                observs : ObservationStore,
                colles  : ColleStore) {
        // supprimer tous les élèves de la classe
        item.eleves.forEach { eleve in
            eleves.delete(eleve,
                          observs: observs,
                          colles: colles)
        }

        // zeroize du pointeur de l'établissement vers la classe
        if let etablissement = item.etablissement {
            let etablissementManager = EtablissementManager()
            etablissementManager.retirer(classe: item,
                                         deEtablissement: etablissement)
        }

        // retirer la classe de la liste
        items.removeAll {
            $0.id == item.id
        }
    }

    static var exemple = ClasseStore()
}

extension ClasseStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

final class Classe: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var etablissement: Etablissement?
    @Published
    var niveau: NiveauClasse = .n6ieme
    @Published
    var numero: Int = 1
    @Published
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
