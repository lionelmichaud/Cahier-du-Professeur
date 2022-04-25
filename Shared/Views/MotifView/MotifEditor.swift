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
                .padding(.trailing)
            Divider()
            VStack (alignment: .leading) {
                CasePicker(pickedCase: $motif.nature,
                           label: "Motif")
                .pickerStyle(.menu)
                if motif.nature == .autre {
                    TextEditor(text: $motif.description)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct MotifEditor_Previews: PreviewProvider {
    static var previews: some View {
        MotifEditor(motif: .constant(Motif(nature: .autre, description: "Une description")))
    }
}
