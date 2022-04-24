//
//  EleveObservRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct EleveObservRow: View {
    var observ: Observation
    @EnvironmentObject var observStore : ObservationStore
    @Environment(\.horizontalSizeClass) var hClass

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.red)
            if hClass == .compact {
                Text(observ.date.stringShortDate)
            } else {
                Text(observ.date.stringLongDateTime)
            }

            Spacer()

            Button {
                if let index = observStore.items.firstIndex(where: {
                    $0.id == observ.id
                }) {
                    observStore.items[index].isConsignee.toggle()
                }
            } label: {
                Image(systemName: observ.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                if hClass == .compact {
                    Text("Notifié")
                } else {
                    Text("Notifiée aux parents")
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing)

            Button {
                if let index = observStore.items.firstIndex(where: { $0.id == observ.id }) {
                    observStore.items[index].isVerified.toggle()
                }
            } label: {
                Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                if hClass == .compact {
                    Text("Vérifié")
                } else {
                    Text("Signature des parents vérifiée")
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct EleveObservRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EleveObservRow(observ: Observation.exemple)
                .previewDevice("iPad mini (6th generation)")
                .previewLayout(.sizeThatFits)
            EleveObservRow(observ: Observation.exemple)
                .previewDevice("iPhone Xs")
                .previewLayout(.sizeThatFits)
        }
    }
}
