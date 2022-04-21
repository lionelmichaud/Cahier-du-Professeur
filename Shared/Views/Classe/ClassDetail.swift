//
//  ClassDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import AppFoundation
import HelpersView

struct ClassDetail: View {
    @Binding var classe: Classe
    let isEditing : Bool
    var isNew     : Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: "person.3.fill")
                    .sfSymbolStyling()
                    .foregroundColor(classe.niveau.color)

                HStack {
                    if isNew || isEditing {
                        Text("Niveau")
                        CasePicker(pickedCase: $classe.niveau, label: "Niveau")
                            .pickerStyle(.menu)
                    } else {
                        Text("Classe de \(classe.displayString)")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)

                Spacer()

                if isNew || isEditing {
                    Text("Numéro")
                    Picker("Numéro de classe", selection: $classe.numero) {
                        ForEach(1...8, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("\(classe.nbOfEleves) élèves")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                Spacer()

                if isNew || isEditing {
                    AmountEditView(label: "Heures",
                                   amount: $classe.heures,
                                   validity: .poz,
                                   currency: false)
                    .focused($isFocused)
                    .frame(maxWidth: 150)
                } else {
                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
        .listRowSeparator(.hidden)
        .onAppear {
            isFocused = true
        }
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                ClassDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                            isEditing : false,
                            isNew     : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            NavigationView {
                EmptyView()
                ClassDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                            isEditing : false,
                            isNew     : false)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
        }
    }
}
