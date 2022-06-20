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
    @Binding
    var ressourceIsModified: Bool
    @FocusState
    private var isNameFocused: Bool

    var body: some View {
        Form {
            VStack {
                HStack {
                    Image(systemName: "latch.2.case")
                        .sfSymbolStyling()
                        .foregroundColor(.accentColor)
                    TextField("Nom de la ressource", text: $ressource.name)
                        //.font(.title2)
                        .textFieldStyle(.roundedBorder)
                        .focused($isNameFocused)
                        .onChange(of: ressource.name,
                                  perform: { newValue in
                            ressourceIsModified = true
                            print ("ressourceIsModified = \(ressourceIsModified) name changed to \(ressource.name)")
                        })
                }

                Stepper(value : $ressource.maxNumber,
                        in    : 1 ... 20,
                        step  : 1) {
                    HStack {
                        Text("Quantité disponible")
                        Spacer()
                        Text("\(ressource.maxNumber)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: ressource.maxNumber,
                      perform: { newValue in
                ressourceIsModified = true
                print ("ressourceIsModified = \(ressourceIsModified) maxNumber changed to \(ressource.maxNumber)")

            })
        }
    }
}

struct RessourceEditor_Previews: PreviewProvider {
    static var previews: some View {
        RessourceEditor(ressource: .constant(Ressource(name: "Kit robot",
                                                       maxNumber: 12)),
                        ressourceIsModified: .constant(false))
    }
}
