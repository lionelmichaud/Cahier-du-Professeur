//
//  ObservBrowserRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/04/2022.
//

import SwiftUI
import HelpersView

struct ObservBrowserRow: View {
    let eleve : Eleve
    var observ: Observation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(observ.color)
                Text("\(observ.date.stringShortDate) à \(observ.date.stringTime)")

                Spacer()

                ObservNotifIcon(observ: observ)
                ObservSignIcon(observ: observ)
            }

            EleveLabel(eleve: eleve)
                .font(.caption)
                .foregroundColor(.secondary)

            MotifLabel(motif: observ.motif.nature)
                .font(.caption)
                //.foregroundColor(.secondary)
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
