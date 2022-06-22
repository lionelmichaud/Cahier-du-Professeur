//
//  Mark.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 10/05/2022.
//

import Foundation
import AppFoundation

struct EleveMark: Codable, Hashable, Identifiable {
    var eleveId : UUID
    var type    : MarkEnum = .nonRendu
    var mark    : Double?
    var id      : UUID {
        eleveId
    }
}

enum MarkEnum: Codable {
    case note
    case nonNote
    case absent
    case disp
    case nonRendu
    case inapt
}

extension MarkEnum: PickableEnumP {

    public var pickerString: String {
        switch self {
            case .note:
                return "Noté"
            case .nonNote:
                return "Non noté"
            case .absent:
                return "Absent"
            case .disp:
                return "Dispensé"
            case .nonRendu:
                return "Non rendu"
            case .inapt:
                return "Inapte"
        }
    }
}

