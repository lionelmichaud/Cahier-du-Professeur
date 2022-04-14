//
//  UIState.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

final class UIState: ObservableObject {
    enum Tab: Int, Hashable {
        case userSettings, etablissement, classe, eleve, colle, observation
    }
}
