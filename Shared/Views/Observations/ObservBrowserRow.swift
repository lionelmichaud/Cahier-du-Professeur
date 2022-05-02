//
//  ObservBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/04/2022.
//

import SwiftUI

struct ObservBrowserRow: View {
    let eleve : Eleve
    var observ: Observation

    var body: some View {
        VStack(alignment: .leading) {
            EleveLabel(eleve: eleve)

            HStack {
                Text(observ.date.stringShortDate)
                    .foregroundColor(.secondary)

                Spacer()

                ObservNotifIcon(observ: observ)
                ObservSignIcon(observ: observ)
            }.font(.callout)
        }
    }
}

struct ObservBrowserRow_Previews: PreviewProvider {
    static var previews: some View {
        ObservBrowserRow(eleve  : Eleve.exemple,
                         observ : Observation.exemple)
        .previewLayout(.sizeThatFits)
    }
}
