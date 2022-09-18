//
//  SettingsGeneral.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 18/09/2022.
//

import SwiftUI
import HelpersView

struct SettingsGeneral: View {
    @Preference(\.interoperability)
    var interoperability

    @Preference(\.nameDisplayOrder)
    var nameDisplayOrder

    var body: some View {
        List {
            // Type d'interopérabilité avec les ENT
            Text("Type d'interopérabilité avec les ENT")
            CasePicker(pickedCase: $interoperability,
                       label: "Interopérabilté avec")
            .pickerStyle(.segmented)

            Section {
                // Ordre d'affichage des nms des élèves
                Text("Ordre d'affichage des nms des élèves")
                CasePicker(pickedCase: $nameDisplayOrder,
                           label: "Ordre d'affichage des noms")
                .pickerStyle(.segmented)
            } header: {
                Text("Affichage")
            }
            //.listRowSeparator(.hidden)
        }
        #if os(iOS)
        .navigationTitle("Préférences Générales")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct SettingsGeneral_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneral()
    }
}
