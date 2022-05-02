//
//  ColleBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI

struct ColleBrowserRow: View {
    let eleve : Eleve
    var colle : Colle

    var body: some View {
        VStack(alignment: .leading) {
            EleveLabel(eleve: eleve)

            HStack {
                Text(colle.date.stringShortDate)
                    .foregroundColor(.secondary)

                Spacer()

                ColleNotifIcon(colle: colle)
            }.font(.callout)
        }
    }
}

struct ColleBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        ColleBrowserRow(eleve: Eleve.exemple,
                        colle: Colle.exemple)
    }
}
