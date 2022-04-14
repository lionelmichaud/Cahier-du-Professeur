//
//  NiveauEtablissement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation
import AppFoundation

enum NiveauEtablissement: Int, PickableEnumP, Codable {
    case college
    case lycee
    
    var pickerString: String {
        switch self {
            case .college:
                return "Collège"
            case .lycee:
                return "Lycée"
        }
    }
}

