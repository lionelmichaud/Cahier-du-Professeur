//
//  EleveLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI
import HelpersView

struct EleveLabel: View {
    let eleve      : Eleve
    var fontWeight : Font.Weight = .semibold
    var imageSize  : Image.Scale = .large
    var flagSize   : Image.Scale = .medium

    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .imageScale(imageSize)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(eleve.sexe.color)
            Text(eleve.displayName)
                .fontWeight(fontWeight)
            if eleve.isFlagged {
                Image(systemName: "flag.fill")
                    .imageScale(flagSize)
                    .foregroundColor(.orange)
            }
        }
    }
}

struct EleveLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EleveLabel(eleve      : Eleve.exemple,
                       fontWeight : .regular,
                       imageSize  : .small)
            .previewLayout(.sizeThatFits)

            EleveLabel(eleve: Eleve.exemple)
                .previewLayout(.sizeThatFits)
        }
    }
}
