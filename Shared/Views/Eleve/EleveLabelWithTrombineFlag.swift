//
//  EleveLabelWithTrombineFlag.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 17/06/2022.
//

import SwiftUI
import HelpersView

struct EleveLabelWithTrombineFlag: View {
    @Binding
    var eleve      : Eleve

    @Binding
    var isModified : Bool

    var isEditable : Bool        = true
    var font       : Font        = .title2
    var fontWeight : Font.Weight = .semibold
    var imageSize  : Image.Scale = .large
    var flagSize   : Image.Scale = .medium

    @Preference(\.eleveTrombineEnabled)
    private var eleveTrombineEnabled

    @State
    private var showTrombine = false

    @State
    private var hasPAP = false

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
                    if isEditable {
                        eleve.isFlagged.toggle()
                    }
                } label: {
                    if eleve.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "flag")
                            .foregroundColor(.orange)
                    }
                }
                .onChange(of: eleve.isFlagged) { _ in
                    isModified = true
                }
                // PAP
                Toggle(isOn: isEditable ? $hasPAP : .constant(hasPAP)) {
                    Text("PAP")
                }
                .toggleStyle(.button)
                .controlSize(.small)
                .onChange(of: hasPAP) { newValue in
                    if newValue {
                        if eleve.troubleDys == nil {
                            eleve.troubleDys = .undefined
                        }
                    } else {
                        eleve.troubleDys = nil
                    }
                    isModified = true
                }
            }

            /// Trouble dys
            if let trouble = eleve.troubleDys {
                HStack {
                    // Sexe de cet eleve
                    if isEditable {
                        CasePicker(pickedCase: $eleve.troubleDys.bound, label: "Trouble")
                            .pickerStyle(.menu)
                            .onChange(of: eleve.troubleDys.bound) { _ in
                                isModified = true
                            }
                    } else if let troubleDys = eleve.troubleDys {
                        Text(troubleDys.displayString + ":")
                    }
                    if trouble.additionalTime {
                        Text("1/3 de temps aditionnel")
                    }
                }
            }

            /// Groupe
            if let group = eleve.group {
                Text("Groupe " + group.formatted(.number))
            }

            /// Trombine
            if showTrombine, let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                LoadableImage(imageUrl: trombine)
            }
        }
        .onAppear {
            hasPAP = eleve.troubleDys != nil
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
