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
                .foregroundColor(observ.color)
            if hClass == .compact {
                VStack(alignment: .leading) {
                    Text(observ.date.stringShortDate)
                    Text(observ.motif.nature.displayString)
                        .foregroundColor(.secondary)
                }
                .font(.callout)
            } else {
                VStack(alignment: .leading) {
                    Text(observ.date.stringLongDateTime)
                    Text(observ.motif.nature.displayString)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                if let index = observStore.items.firstIndex(where: { $0.id == observ.id }) {
                    withAnimation {
                        observStore.items[index].isConsignee.toggle()
                    }
                }
            } label: {
                Image(systemName: observ.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(observ.isConsignee ? .green : .gray)
                if hClass == .compact {
                    Text("Notifié")
                        .font(.callout)
                } else {
                    Text("Notifiée aux parents")
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 4)

            Button {
                if let index = observStore.items.firstIndex(where: { $0.id == observ.id }) {
                    withAnimation {
                        observStore.items[index].isVerified.toggle()
                    }
                }
            } label: {
                Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(observ.isVerified ? .green : .gray)
                if hClass == .compact {
                    Text("Vérifié")
                        .font(.callout)
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
