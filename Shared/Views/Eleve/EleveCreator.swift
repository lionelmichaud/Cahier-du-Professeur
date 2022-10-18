//
//  EleveCreator.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 07/10/2022.
//

import SwiftUI
import HelpersView

struct EleveCreator: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var eleveStore: EleveStore
    @Environment(\.dismiss) private var dismiss

    @State
    private var alertItem: AlertItem?

    @State
    private var eleve: Eleve = Eleve(sexe   : .male,
                                     nom    : "",
                                     prenom : "")

    var body: some View {
        Form {
            HStack {
                Image(systemName: "person.fill")
                    .sfSymbolStyling()
                    .foregroundColor(eleve.sexe.color)
                // Sexe de cet eleve
                CasePicker(pickedCase: $eleve.sexe, label: "Sexe")
                    .pickerStyle(.menu)
            }
            TextField("Prénom", text: $eleve.name.givenName.bound)
                .onSubmit {
                    eleve.name.givenName.bound.trim()
                }
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
            TextField("Nom", text: $eleve.name.familyName.bound)
                .onSubmit {
                    eleve.name.familyName.bound.trim()
                }
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
        }
        .alert(item: $alertItem, content: newAlert)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Ajouter") {
                    // supprimer les caracctères blancs au début et à la fin
                    if eleve.name.familyName != nil {
                        eleve.name.familyName = eleve.name.familyName!.trimmed.uppercased()
                    }
                    if eleve.name.givenName != nil {
                        eleve.name.givenName!.trim()
                    }
                    //trim(formName: itemCopy.name)
                    // Ajouter un nouvel élève à la classe
                    if eleveStore.exists(eleve: eleve, in: classe.id) {
                        self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                   message       : Text("Cet élève existe déjà dans cette classe"),
                                                   dismissButton : .default(Text("OK")))
                    } else {
                        withAnimation {
                            ClasseManager()
                                .ajouter(eleve      : &eleve,
                                         aClasse    : &classe,
                                         eleveStore : eleveStore)
                        }
                        dismiss()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Ajouter un élève")
        #endif
    }
}

struct EleveCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                EleveCreator(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                EleveCreator(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedEleveId: TestEnvir.eleveStore.items.first!.id))
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
