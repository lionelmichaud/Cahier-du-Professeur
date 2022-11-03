//
//  RessourceEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 19/06/2022.
//

import SwiftUI
import HelpersView

struct RessourceEditor: View {
    @Binding
    var ressource: Ressource

    @Environment(\.horizontalSizeClass)
    var hClass

    var name: some View {
        HStack {
            Image(systemName: "latch.2.case")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)
            TextField("Nom de la ressource", text: $ressource.name)
                .textFieldStyle(.roundedBorder)
        }
    }

    var quantity: some View {
        Stepper(value : $ressource.maxNumber,
                in    : 1 ... 100,
                step  : 1) {
            HStack {
                Text(hClass == .regular ? "Quantité disponible" : "Quantité")
                Spacer()
                Text("\(ressource.maxNumber)")
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        if hClass == .regular {
            HStack {
                name
                quantity
                    .frame(maxWidth: 280)
            }
        } else {
            GroupBox {
                name
                quantity
            }
        }
    }
}

struct RessourceEditor_Previews: PreviewProvider {
    static var previews: some View {
        RessourceEditor(ressource: .constant(Ressource(name: "Kit robot",
                                                       maxNumber: 12)))
    }
}
