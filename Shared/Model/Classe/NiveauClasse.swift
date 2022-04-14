//
//  Niveau.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation
import AppFoundation

enum NiveauClasse: Int, PickableEnumP, Codable {
    case n6ieme
    case n5ieme
    case n4ieme
    case n3ieme
    case n2nd
    case n1ere
    case terminale

    var pickerString: String {
        switch self {
            case .n6ieme:
                return "6ième"
            case .n5ieme:
                return "5ième"
            case .n4ieme:
                return "4ième"
            case .n3ieme:
                return "3ième"
            case .n2nd:
                return "2nd"
            case .n1ere:
                return "1ère"
            case .terminale:
                return "Terminale"
        }
    }

    var displayString: String {
        switch self {
            case .n6ieme:
                return "6°"
            case .n5ieme:
                return "5°"
            case .n4ieme:
                return "4°"
            case .n3ieme:
                return "3°"
            case .n2nd:
                return "2°"
            case .n1ere:
                return "1°"
            case .terminale:
                return "T°"
        }
    }
}
