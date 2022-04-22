//
//  SchoolStore.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 18/04/2022.
//

import SwiftUI

final class SchoolStore: ObservableObject {

    // MARK: - Properties

    @Published
    var items: [School] = [ ]
    
    var nbOfItems: Int {
        items.count
    }

    // MARK: - Methods

    func exists(_ item: School) -> Bool {
        items.contains(where: { item.id == $0.id})
    }

    func school(withID ID: UUID) -> School? {
        items.first(where: { ID == $0.id})
    }

    func add(_ item: School) {
        items.insert(item, at: 0)
    }

    func delete(_ item  : School,
                classes : ClasseStore,
                eleves  : EleveStore,
                observs : ObservationStore,
                colles  : ColleStore) {
        // supprimer toutes les classes de l'établissement
        item.classesID.forEach { classeId in
            classes.deleteClasse(withID: classeId)
        }
        // retirer l'établissement de la liste
        items.removeAll {
            $0.id == item.id
        }
    }

    func sorted(niveau: NiveauSchool) -> Binding<[School]> {
        Binding<[School]>(
            get: {
                self.items
                    .filter {
                        $0.niveau == niveau
                    }
                    .sorted { $0.nom < $1.nom }
            },
            set: { items in
                for school in items {
                    if let index = self.items.firstIndex(where: { $0.id == school.id }) {
                        self.items[index] = school
                    }
                }
            }
        )
    }

    static var exemple = SchoolStore()
}

extension SchoolStore: CustomStringConvertible {
    var description: String {
        var str = ""
        items.forEach { item in
            str += (String(describing: item) + "\n")
        }
        return str
    }
}
