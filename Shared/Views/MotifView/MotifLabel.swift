//
//  MotifLabel.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 17/05/2022.
//

import SwiftUI

struct MotifLabel: View {
    let motif      : MotifEnum
    var fontWeight : Font.Weight = .semibold
    var imageSize  : Image.Scale = .large

    var body: some View {
        HStack {
            Image(systemName: "info.circle.fill")
                .imageScale(imageSize)
                .symbolRenderingMode(.hierarchical)
                //.foregroundColor(eleve.sexe.color)
            Text(motif.displayString)
                .fontWeight(fontWeight)
                .foregroundColor(.secondary)
        }
    }
}

struct MotifLabel_Previews: PreviewProvider {
    static var previews: some View {
        MotifLabel(motif: MotifEnum.leconNonApprise)
    }
}
