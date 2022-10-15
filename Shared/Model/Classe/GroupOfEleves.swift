//
//  GroupOfEleves.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 25/09/2022.
//

import Foundation

struct GroupOfEleves: Identifiable {

    // MARK: - Properties

    var id       : Int { number }
    var number   : Int
    var elevesID : [UUID] = []

    // MARK: - Initializers

    init(number   : Int,
         elevesID : [UUID] = []) {
        self.number = number
        self.elevesID = elevesID
    }

    // MARK: - Methods

    /// Retourne le tableau des élèves appartenant au groupe
    func eleves(eleveStore : EleveStore) -> [Eleve] {
        elevesID.compactMap { eleveID in
            eleveStore.item(withID: eleveID)
        }
    }

    /// Retourne le tableau des noms des élèves appartenant au groupe
    func elevesNames(eleveStore : EleveStore,
                     order      : NameDisplayOrder = .prenomNom) -> [String] {
        elevesID.compactMap { eleveID in
            eleveStore.item(withID: eleveID)?.displayName(order)
        }
    }
}

extension GroupOfEleves: CustomStringConvertible {
    var description: String {
        return """

        GROUPE:
           Numéro  : \(number)
           Eleves: \(elevesID))
        """

    }
}
