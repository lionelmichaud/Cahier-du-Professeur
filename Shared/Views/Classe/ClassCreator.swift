//
//  ClassCreator.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/06/2022.
//

import SwiftUI
import HelpersView

struct ClassCreator: View {
    let addNewItem: (Classe) -> Void
    @State
    private var newClasse: Classe = Classe(niveau: .n6ieme, numero: 1)
    @FocusState
    private var isHoursFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            HStack {
                Image(systemName: "person.3.fill")
                    .sfSymbolStyling()
                    .foregroundColor(newClasse.niveau.color)
                // niveau de cette classe
                CasePicker(pickedCase: $newClasse.niveau,
                           label: "Niveau")
                    .pickerStyle(.menu)
                // numéro de cette classe
                Picker("Numéro", selection: $newClasse.numero) {
                    ForEach(1...8, id: \.self) { num in
                        Text(String(num))
                    }
                }
                .pickerStyle(.menu)
                Toggle(isOn: $newClasse.segpa) {
                    Text("SEGPA")
                        .font(.caption)
                }
                .toggleStyle(.button)
                
                Spacer()
                
                AmountEditView(label: "Heures",
                               amount: $newClasse.heures,
                               validity: .poz,
                               currency: false)
                .focused($isHoursFocused)
                .frame(maxWidth: 150)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Ok") {
                    // Ajouter le nouvel établissement
                    withAnimation {
                        addNewItem(newClasse)
                    }
                    dismiss()
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Nouvelle Classe")
        #endif
    }
}

struct ClassCreator_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            ClassCreator(addNewItem: { _ in })
        }
    }
}
