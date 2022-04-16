//
//  Etablissement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

final class EtablissementStore: ObservableObject {
    @Published
    var items: [Etablissement] = [ ]
    var nbOfItems: Int {
        items.count
    }

    func exists(_ item: Etablissement) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

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

    func sorted(niveau: NiveauEtablissement) -> Binding<[Etablissement]> {
        Binding<[Etablissement]>(
            get: {
                self.items
                    .filter {
                        $0.niveau == niveau
                    }
                    .sorted { $0.nom < $1.nom }
            },
            set: { items in
                for etablissement in items {
                    if let index = self.items.firstIndex(where: { $0.id == etablissement.id }) {
                        self.items[index] = etablissement
                    }
                }
            }
        )
    }

    static var exemple = EtablissementStore()
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
