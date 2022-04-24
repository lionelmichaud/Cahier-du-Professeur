//
//  EleveColleRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveColleRow: View {
    let colle: Colle
    @EnvironmentObject var colleStore: ColleStore

    var body: some View {
        HStack {
            Image(systemName: "lock")
                .sfSymbolStyling()
                .foregroundColor(.red)
            Text(colle.date.stringShortDate)

            Spacer()

            Button {
                if let index = colleStore.items.firstIndex(where: {
                    $0.id == colle.id
                }) {
                    colleStore.items[index].isConsignee.toggle()
                }
            } label: {
                Image(systemName: colle.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                Text("Notifié")
            }
            .buttonStyle(.plain)
            .padding(.trailing)

            Button {
                if let index = colleStore.items.firstIndex(where: {
                    $0.id == colle.id
                }) {
                    colleStore.items[index].isVerified.toggle()
                }
            } label: {
                Image(systemName: colle.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                Text("Vérifié")
            }
            .buttonStyle(.plain)
        }
    }
}

struct EleveColleRow_Previews: PreviewProvider {
    static var previews: some View {
        EleveColleRow(colle: Colle.exemple)
    }
}
