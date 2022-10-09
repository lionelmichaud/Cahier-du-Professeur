//
//  EleveNameGroupBox.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 09/10/2022.
//

import SwiftUI
import HelpersView

struct EleveNameGroupBox: View {
    @Binding
    var eleve: Eleve

    var isEditing: Bool

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    // MARK: - Computed Properties

    private var sex: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)
            // Sexe de cet eleve
            CasePicker(pickedCase: $eleve.sexe, label: "Sexe")
                .pickerStyle(.menu)
        }
    }
    private var prenom: some View {
        TextField("Prénom", text: $eleve.name.givenName.bound)
            .onSubmit {
                eleve.name.givenName.bound.trim()
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
    }
    private var nom: some View {
        TextField("Nom", text: $eleve.name.familyName.bound)
            .onSubmit {
                eleve.name.familyName.bound.trim()
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
    }

    var body: some View {
        GroupBox {
            if isEditing {
                ViewThatFits(in: .horizontal) {
                    // priorité 1
                    HStack {
                        sex
                        if nameDisplayOrder == .nomPrenom {
                            nom
                            prenom
                        } else {
                            prenom
                            nom
                        }
                    }
                    // priorité 2
                    VStack {
                        sex
                        if nameDisplayOrder == .nomPrenom {
                            nom
                            prenom
                        } else {
                            prenom
                            nom
                        }
                    }
                }
            } else {
                EleveLabelWithTrombineFlag(eleve: $eleve)
            }
        }
    }
}

struct EleveNameGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
                EleveNameGroupBox(eleve: .constant(TestEnvir.eleveStore.items.first!),
                                  isEditing: true)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDisplayName("Editable")
                .previewDevice("iPhone 13")

                EleveNameGroupBox(eleve: .constant(TestEnvir.eleveStore.items.first!),
                                  isEditing: false)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDisplayName("Non Editable")
                .previewDevice("iPhone 13")
        }
    }
}
