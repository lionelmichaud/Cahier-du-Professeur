//
//  Eleve.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class EleveStore: ObservableObject {
    @Published
    var items: [Eleve] = [ ]
    var nbOfItems: Int {
        items.count
    }

    func exists(_ item: Eleve) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    func add(_ item: Eleve) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : Eleve,
                observs : ObservationStore,
                colles  : ColleStore) {
        // zeroize du pointeur des colles vers l'élève
        // supprimer la colle de son store
        item.colles.forEach { colle in
            colles.delete(colle)
        }

        // zeroize du pointeur des observations vers l'élève
        // supprimer l'observation de son store
        item.observs.forEach { observ in
            observs.delete(observ)
        }

        // zeroize du pointeur de la classe vers l'élève
        if let classe = item.classe {
            let classeManager = ClasseManager()
//            classeManager.retirer(eleve: item,
//                                  deClasse: classe)
        }

        // retirer l'élève de la liste
        items.removeAll {
            $0.id == item.id
        }
    }

    static var exemple : EleveStore = {
        let store = EleveStore()
        store.items.append(Eleve.exemple)
        return store
    }()
}

extension EleveStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}

final class Eleve: ObservableObject, Identifiable {
    var id = UUID()
    @Published
    var sexe   : Sexe = .male
    @Published
    var name   : PersonNameComponents = PersonNameComponents()
    @Published
    var classe : Classe?
    @Published
    var colles : [Colle] = [ ]
    @Published
    var observs : [Observation] = [ ]

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
           Observations: \(String(describing: observs).withPrefixedSplittedLines("     "))
           Colles: \(String(describing: colles).withPrefixedSplittedLines("     "))
        """
    }
}
