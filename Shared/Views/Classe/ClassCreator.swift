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

    var niveau: some View {
        HStack {
            // niveau de cette classe
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(newClasse.niveau.color)

            CasePicker(pickedCase: $newClasse.niveau,
                       label: "Niveau")
            .pickerStyle(.menu)
        }
    }

    var numero: some View {
        Picker("Numéro", selection: $newClasse.numero) {
            ForEach(1...10, id: \.self) { num in
                Text(String(num))
            }
        }
        .pickerStyle(.menu)
    }

    var segpa: some View {
        Toggle(isOn: $newClasse.segpa.animation()) {
            Text("SEGPA")
                .font(.caption)
        }
        .toggleStyle(.button)
        .controlSize(.large)
    }

    var body: some View {
        Form {
            ViewThatFits(in: .horizontal) {
                // priorité 1
                HStack {
                    // niveau de cette classe
                    niveau
                    Spacer(minLength: 50)

                    // numéro de cette classe
                    numero
                    Spacer(minLength: 50)
                        //.frame(maxWidth: 140)

                    // SEGPA ou pas
                    segpa
                }
                // priorité 2
                VStack {
                    // niveau de cette classe
                    niveau

                    // numéro de cette classe
                    numero

                    // SEGPA ou pas
                    segpa
                }
            }
            AmountEditView(label: "Nombre d'heures de cours par semaine",
                           amount: $newClasse.heures,
                           validity: .poz,
                           currency: false)
            .focused($isHoursFocused)

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
        .onAppear {
            isHoursFocused = true
        }
    }
}

struct ClassCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ClassCreator(addNewItem: { _ in })
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ClassCreator(addNewItem: { _ in })
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
