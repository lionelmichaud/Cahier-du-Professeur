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

    var isEditable : Bool        = true
    var font       : Font        = .title3
    var fontWeight : Font.Weight = .semibold
    var imageSize  : Image.Scale = .large
    var flagSize   : Image.Scale = .medium

    @Preference(\.eleveTrombineEnabled)
    private var eleveTrombineEnabled

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @Environment(\.horizontalSizeClass)
    var hClass

    @State
    private var showTrombine = false

    private var hasPAP : Binding<Bool> {
        Binding(
            get: {
                self.eleve.troubleDys != nil
            },
            set: { newValue in
                if newValue {
                    if eleve.troubleDys == nil {
                        eleve.troubleDys = .undefined
                    }
                } else {
                    eleve.troubleDys = nil
                }
            }
        )
    }

    var body: some View {
        VStack {
            HStack {
                /// Trombine
                Button {
                    if eleveTrombineEnabled {
                        withAnimation {
                            showTrombine.toggle()
                        }
                    }
                } label: {
                    Image(systemName: "person.fill")
                        .imageScale(imageSize)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(eleve.sexe.color)
                }

                /// Nom
                if hClass == .compact {
                    Text(eleve.displayName2lines(nameDisplayOrder))
                        .font(font)
                        .fontWeight(fontWeight)
                } else {
                    Text(eleve.displayName)
                }

                /// Flag
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
                .disabled(!isEditable)

                /// PAP
                if isEditable {
                    Toggle(isOn: hasPAP.animation()) {
                        Text("PAP")
                    }
                    .toggleStyle(.button)
                    .controlSize(.small)
                }
            }

            /// Trouble dys
            if let trouble = eleve.troubleDys {
                HStack {
                    // Sexe de cet eleve
                    if isEditable {
                        CasePicker(pickedCase: $eleve.troubleDys.bound, label: "Trouble")
                            .pickerStyle(.menu)
                        if trouble.additionalTime {
                            Text("1/3 de temps aditionnel")
                        }
                    } else if let troubleDys = eleve.troubleDys {
                        Text(troubleDys.displayString + ":")
                            .padding(.top)
                        if trouble.additionalTime {
                            Text("1/3 de temps aditionnel")
                                .padding(.top)
                         }
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
//            hasPAP = eleve.troubleDys != nil
        }
    }
}

struct EleveLabelWithTrombineFlag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EleveLabelWithTrombineFlag(eleve      : .constant(Eleve.exemple),
                                       isEditable : false)
            .previewDevice("iPhone 13")

            EleveLabelWithTrombineFlag(eleve      : .constant(Eleve.exemple),
                                       isEditable : true)
            .previewDevice("iPad mini (6th generation)")
        }
    }
}
