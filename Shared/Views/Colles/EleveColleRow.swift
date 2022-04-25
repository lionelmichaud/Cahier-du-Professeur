//
//  EleveColleRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct EleveColleRow: View {
    let colle: Colle
    @EnvironmentObject var colleStore: ColleStore
    @Environment(\.horizontalSizeClass) var hClass

    var body: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.red)
            if hClass == .compact {
                Text(colle.date.stringShortDate)
                    .font(.callout)
            } else {
                Text(colle.date.stringLongDateTime)
            }

            Spacer()

            Button {
                if let index = colleStore.items.firstIndex(where: {
                    $0.id == colle.id
                }) {
                    colleStore.items[index].isConsignee.toggle()
                }
            } label: {
                Image(systemName: colle.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(colle.isConsignee ? .green : .gray)
                if hClass == .compact {
                    Text("Notifié")
                        .font(.callout)
                } else {
                    Text("Notifiée à la vie scolaire")
                }
            }
            .buttonStyle(.plain)
            .padding(.trailing)

            Button {
                if let index = colleStore.items.firstIndex(where: { $0.id == colle.id }) {
                    colleStore.items[index].isVerified.toggle()
                }
            } label: {
                Image(systemName: colle.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(colle.isVerified ? .green : .gray)
                if hClass == .compact {
                    Text("Exéc.")
                        .font(.callout)
                } else {
                    Text("Exécutée par l'élève")
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct EleveColleRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EleveColleRow(colle: Colle.exemple)
                .previewDevice("iPad mini (6th generation)")
                .previewLayout(.sizeThatFits)
            EleveColleRow(colle: Colle.exemple)
                .previewDevice("iPhone Xs")
                .previewLayout(.sizeThatFits)
        }
    }
}