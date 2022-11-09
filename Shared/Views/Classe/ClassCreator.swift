//
//  ClassCreator.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/06/2022.
//

import SwiftUI
import HelpersView

struct ClassCreator: View {
    @Binding
    var inSchool: School

    @EnvironmentObject private var classeStore : ClasseStore

    @State
    private var alertItem : AlertItem?

    @State
    private var newClasse: Classe = Classe(niveau: .n6ieme, numero: 1)

    @FocusState
    private var isHoursFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var niveau: some View {
        HStack {
            // niveau de cette classe
            Image(systemName: "person.3.sequence.fill")
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
        .alert(item: $alertItem, content: newAlert)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Ok") {
                    /// Ajouter une nouvelle classe
                    if classeStore.exists(classe: newClasse, in: inSchool.id) {
                        self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                   message       : Text("Cette classe existe déjà dans cet établissement"),
                                                   dismissButton : .default(Text("OK")))
                    } else if !isCompatible(newClasse, inSchool) {
                        self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                   message       : Text("Ce niveau de classe n'existe pas dans ce type d'établissement"),
                                                   dismissButton : .default(Text("OK")))
                    } else {
                        var _classe = newClasse
                        withAnimation {
                            SchoolManager()
                                .ajouter(classe      : &_classe,
                                         aSchool     : &inSchool,
                                         classeStore : classeStore)
                        }
                        dismiss()
                    }
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

    func isCompatible(_ classe: Classe, _ school: School) -> Bool {
        switch classe.niveau {
            case .n6ieme, .n5ieme, .n4ieme, .n3ieme:
                return school.niveau == .college

            case .n2nd, .n1ere, .n0terminale:
                return school.niveau == .lycee
        }
    }
}

struct ClassCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ClassCreator(inSchool: .constant(TestEnvir.schoolStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ClassCreator(inSchool: .constant(TestEnvir.schoolStore.items.first!))
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
