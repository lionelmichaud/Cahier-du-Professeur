//
//  SettingsPage1.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 22/05/2022.
//

import SwiftUI

struct SettingsPage1: View {
    @Preference(\.maxBonusMalus) var maxBonusMalus
    @Preference(\.maxBonusIncrement) var maxBonusIncrement

    var body: some View {
        List {
            Section("Bonus / Malus") {
                Stepper(value : $maxBonusMalus,
                        in    : 0 ... 20,
                        step  : 1) {
                    HStack {
                        Text("Bonus / Malus maximum")
                        Spacer()
                        Text("\(maxBonusMalus.formatted(.number.precision(.fractionLength(0))))")
                            .foregroundColor(.secondary)
                    }
                }

                Stepper(value : $maxBonusIncrement,
                        in    : 0 ... 1,
                        step  : 0.25) {
                    HStack {
                        Text("Incrément de Bonus/Malus")
                        Spacer()
                        Text("\(maxBonusIncrement.formatted(.number.precision(.fractionLength(2))))")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Préférences")
        //.navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsPage1_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage1()
    }
}
