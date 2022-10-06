//
//  ColleBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI
import HelpersView

struct ColleBrowserRow: View {
    let eleve : Eleve
    var colle : Colle

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "lock")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(colle.color)
                Text("\(colle.date.stringShortDate) à \(colle.date.stringTime)")
                    .font(.callout)

                Spacer()

                ColleNotifIcon(colle: colle)
            }

            EleveLabel(eleve: eleve)
                .font(.callout)
                .foregroundColor(.secondary)

            MotifLabel(motif: colle.motif)
                .font(.callout)
            //.foregroundColor(.secondary)
        }
    }
}

struct ColleBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        ColleBrowserRow(eleve: Eleve.exemple,
                        colle: Colle.exemple)
        .previewLayout(.sizeThatFits)
    }
}
