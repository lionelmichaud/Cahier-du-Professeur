//
//  Mark.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 10/05/2022.
//

import Foundation

struct Mark: Codable, Hashable {
    var mark    : Int?
    var eleveId : UUID
}
