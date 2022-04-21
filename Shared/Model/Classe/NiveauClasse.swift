//
//  Niveau.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI
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
                return "6E"
            case .n5ieme:
                return "5E"
            case .n4ieme:
                return "4E"
            case .n3ieme:
                return "3E"
            case .n2nd:
                return "2E"
            case .n1ere:
                return "1E"
            case .terminale:
                return "T"
        }
    }

    var color: Color {
        ColorOptions.all[self.rawValue]
    }
}
