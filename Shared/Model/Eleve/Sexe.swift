//
//  Sexe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation
import AppFoundation

// MARK: - Sexe

public enum Sexe: Int, PickableEnumP, Codable {
    case male
    case female

    public var displayString: String {
        switch self {
            case .male:
                return "G"
            case .female:
                return "F"
        }
    }
    public var pickerString: String {
        switch self {
            case .male:
                return "Garçon"
            case .female:
                return "Fille"
        }
    }
}
