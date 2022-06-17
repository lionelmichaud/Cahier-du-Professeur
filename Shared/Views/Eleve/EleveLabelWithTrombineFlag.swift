//
//  EleveLabelWithTrombineFlag.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 17/06/2022.
//

import SwiftUI

struct EleveLabelWithTrombineFlag: View {
    @Binding var eleve      : Eleve
    @Binding var isModified : Bool
    var font       : Font        = .title2
    var fontWeight : Font.Weight = .semibold
    var imageSize  : Image.Scale = .large
    var flagSize   : Image.Scale = .medium
    @Preference(\.eleveTrombineEnabled)
    private var eleveTrombineEnabled
    @State
    private var showTrombine = false

    var body: some View {
        VStack {
            HStack {
                // Trombine
                Button {
                    if eleveTrombineEnabled {
                        showTrombine.toggle()
                    }
                } label: {
                    Image(systemName: "person.fill")
                        .imageScale(imageSize)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(eleve.sexe.color)
                }
                // Nom
                Text(eleve.displayName)
                    .font(font)
                    .fontWeight(fontWeight)
                // Flag
                Button {
                    eleve.isFlagged.toggle()
                } label: {
                    if eleve.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "flag")
                            .foregroundColor(.orange)
                    }
                }
                .onChange(of: eleve.isFlagged) { newValue in
                    isModified = true
                }
            }
            if showTrombine, let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                LoadableImage(imageUrl: trombine)
            }
        }
    }
}

struct EleveLabelWithTrombineFlag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EleveLabelWithTrombineFlag(eleve      : .constant(Eleve.exemple),
                                       isModified : .constant(false),
                                       fontWeight : .regular,
                                       imageSize  : .small)
            .previewLayout(.sizeThatFits)

            EleveLabelWithTrombineFlag(eleve: .constant(Eleve.exemple),
                                       isModified : .constant(false))
                .previewLayout(.sizeThatFits)
        }
    }
}
