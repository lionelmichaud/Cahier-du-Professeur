//
//  Etablissement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class EtablissementStore: ObservableObject {
    @Published
    var items: [Etablissement] = [ ]

    func add(_ item: Etablissement) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : Etablissement,
                classes : ClasseStore,
                eleves  : EleveStore,
                observs : ObservationStore,
                colles  : ColleStore) {
        // supprimer toutes les classes de l'établissement
        item.classes.forEach { classe in
            classes.delete(classe,
                           eleves: eleves,
                           observs: observs,
                           colles: colles)
        }
        // retirer l'établissement de la liste
        items.removeAll {
            $0.id == item.id
        }
    }

    static let exemple : EtablissementStore = {
        let store = EtablissementStore()
        store.items.append(Etablissement.exemple)
        store.items.append(Etablissement(niveau: .lycee, nom: "Sainte-Marie"))
        return store
    }()
}

extension EtablissementStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

final class Etablissement: ObservableObject, Identifiable {
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

    init(niveau: NiveauEtablissement,
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
           Classes: \(String(describing: classes).withPrefixedSplittedLines("     "))
        """
    }
}
