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
                .sfSymbolStyling()
                .foregroundColor(.red)
            if hClass == .compact {
                Text(observ.date.stringShortDate)
            } else {
                Text(observ.date.formatted(date: .long, time: .shortened))
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
                Text("Notifié")
            }
            .buttonStyle(.plain)
            .padding(.trailing)

            Button {
                if let index = observStore.items.firstIndex(where: {
                    $0.id == observ.id
                }) {
                    observStore.items[index].isVerified.toggle()
                }
            } label: {
                Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                Text("Vérifié")
            }
            .buttonStyle(.plain)
        }
    }
}

struct EleveObservRow_Previews: PreviewProvider {
    static var previews: some View {
        EleveObservRow(observ: Observation.exemple)
            .previewLayout(.sizeThatFits)
    }
}
