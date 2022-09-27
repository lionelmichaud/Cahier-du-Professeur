//
//  TroubleDys.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/09/2022.
//

import Foundation
import AppFoundation

enum TroubleDys: String, PickableEnumP, Codable {
    case dyslexie
    case dyspraxie
    case dysorthographie
    case dysgraphie
    case dysorthophonie
    case dyscalculie
    case dyschromatopsie
    case tsa
    case begaiement
    case tda
    case undefined

    var pickerString: String {
        displayString
    }

    var displayString: String {
        switch self {
            case .dyslexie:
                return "Dyslexie"
            case .dyspraxie:
                return "Dyspraxie"
            case .dysorthographie:
                return "Dysorthographie"
            case .dysgraphie:
                return "Dysgraphie"
            case .dysorthophonie:
                return "Dysorthophonie"
            case .dyschromatopsie:
                return "Dyschromatopsie"
            case .dyscalculie:
                return "Dyscalculie"
            case .tsa:
                return "TSA (autisme)"
            case .begaiement:
                return "Bégaiement"
            case .tda:
                return "Trouble de l'attention"
            case .undefined:
                return "Indéfini"
        }
    }

    var additionalTime: Bool {
        switch self {
            case .dyslexie, .dyspraxie, .dysorthographie,
                    .dysgraphie, .dyscalculie, .tsa, .tda:
                return true

            case .dysorthophonie, .dyschromatopsie, .begaiement, .undefined:
                return false
        }
    }
}

extension Optional where Wrapped == TroubleDys {
    private var _bound: TroubleDys? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    var bound: TroubleDys {
        get {
            return _bound ?? .undefined
        }
        set {
            _bound = newValue
        }
    }
}
