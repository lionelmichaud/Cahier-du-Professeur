//
//  SettingsClasse.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 22/05/2022.
//

import SwiftUI

struct SettingsClasse: View {
    @Preference(\.classeAppreciation)
    var classeAppreciation
    @Preference(\.classeAnnotation)
    var classeAnnotation

    var body: some View {
        List {
            Section("Champs") {
                Toggle("Appréciation", isOn: $classeAppreciation)
                Toggle("Annotation", isOn: $classeAnnotation)
            }
        }
        #if os(iOS)
        .navigationTitle("Préférences Classe")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct SettingsClasse_Previews: PreviewProvider {
    static var previews: some View {
        SettingsClasse()
    }
}
