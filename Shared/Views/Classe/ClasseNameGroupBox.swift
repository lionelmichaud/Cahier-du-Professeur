//
//  ClasseNameGroupBox.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 09/10/2022.
//

import SwiftUI
import HelpersView

struct ClasseNameGroupBox: View {
    @Binding
    var classe: Classe

    var body: some View {
        GroupBox {
            HStack {
                ClasseAcronym(classe: classe)

                /// Flag de la classe
                Button {
                    withAnimation {
                        classe.isFlagged.toggle()
                    }
                } label: {
                    if classe.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "flag")
                            .foregroundColor(.orange)
                    }
                }

                /// SEGPA ou pas
                Toggle(isOn: $classe.segpa.animation()) {
                    Text("SEGPA")
                        .font(.caption)
                }
                .toggleStyle(.button)
                .controlSize(.regular)

                //Spacer()

                /// Nombre d'heures d'enseignement pour cette classe
                AmountEditView(label: "Heures",
                               amount: $classe.heures,
                               validity: .poz,
                               currency: false)
                .frame(maxWidth: 150)
            }
        }
        .padding(.horizontal)
    }
}

struct ClasseNameGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClasseNameGroupBox(classe: .constant(Classe.exemple))
                .previewDisplayName("Editable")
                .previewDevice("iPhone 13")

            ClasseNameGroupBox(classe: .constant(Classe.exemple))
                .previewDisplayName("Non Editable")
                .previewDevice("iPhone 13")
        }
    }
}
