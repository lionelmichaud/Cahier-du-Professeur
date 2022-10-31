//
//  Event.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 24/10/2022.
//

import Foundation

struct Event: Identifiable, Hashable, Codable {

    // MARK: - Type Properties

    static let exemple = Event(date: Date.now,
                               name: "Evénement")
    // MARK: - Properties

    var id = UUID()
    var date : Date
    var name : String = ""

    // MARK: - Initializers

    init(
        date : Date   = Date.now,
        name : String = ""
    ) {
        self.date = date
        self.name = name
    }
}

extension Event: CustomStringConvertible {
    var description: String {
        """

        Nom    : \(name)
        Date   : \(date.stringShortDate)
        """
    }
}
