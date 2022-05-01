//
//  MotifEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 25/04/2022.
//

import SwiftUI
import HelpersView

struct MotifEditor: View {
    @Binding
    var motif: Motif

    var body: some View {
        HStack(alignment: .center) {
            Text("Motif")
                .foregroundColor(.secondary)

            Divider()

            VStack(alignment: .leading) {
                CasePicker(pickedCase: $motif.nature.animation(),
                           label: "Motif")
                .pickerStyle(.menu)
                .onChange(of: motif.nature) { newValue in
                    if newValue != .autre {
                        motif.descriptionMotif = ""
                    }
                }

                if motif.nature == .autre {
                    TextEditor(text: $motif.descriptionMotif)
                        .multilineTextAlignment(.leading)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                }
            }
        }
    }
}

struct MotifEditor_Previews: PreviewProvider {
    static var previews: some View {
        MotifEditor(motif: .constant(Motif(nature: .autre, descriptionMotif: "Une description")))
    }
}
