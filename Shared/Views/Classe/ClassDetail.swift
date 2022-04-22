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
    @Binding
    var classe    : Classe
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewEleve = false
    @State
    private var newEleve = Eleve.exemple
    @FocusState
    private var isHoursFocused: Bool

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: "person.3.fill")
                    .sfSymbolStyling()
                    .foregroundColor(classe.niveau.color)

                // niveau de cette classe
                HStack {
                    if isNew {
                        Text("Niveau")
                        CasePicker(pickedCase: $classe.niveau, label: "Niveau")
                            .pickerStyle(.menu)
                    } else {
                        Text(classe.displayString)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // numéro de cette classe
                if isNew {
                    Text("Numéro")
                    Picker("Numéro de classe", selection: $classe.numero) {
                        ForEach(1...8, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.menu)
                }

                Spacer()

                // nombre d'heures d'enseignement pour cette classe
                if isNew || isEditing {
                    AmountEditView(label: "Heures",
                                   amount: $classe.heures,
                                   validity: .poz,
                                   currency: false)
                    .focused($isHoursFocused)
                    .frame(maxWidth: 150)
                } else {
                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowSeparator(.hidden)

            // élèves dans la classe
            if !isNew {
                // titre
                Text(classe.elevesLabel)
                    .font(.title3)
                    .fontWeight(.bold)

                // édition de la liste des élèves
                ForEach(classe.elevesID, id: \.self) { eleveId in
                    if let eleve = eleveStore.eleve(withID: eleveId) {
                        ClasseEleveRow(eleve: eleve)
                    } else {
                        Text("élève non trouvé: \(eleveId)")
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        isModified = true
                        delete(eleveIndex: index)
                    }
                })
                .onMove(perform: moveEleve)

                // ajouter un élève
                Button {
                    isModified = true
                    newEleve = Eleve.exemple
                    isAddingNewEleve = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Ajouter un élève")
                    }
                }
                .buttonStyle(.borderless)

            }
        }
        #if os(iOS)
        .navigationTitle("Classe")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            isHoursFocused = isNew
        }
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationView {
                Text("Hello")
//                ClasseEditor(school : $school,
//                             classe : $newClasse,
//                             isNew  : true)
            }
        }
    }

    private func moveEleve(from indexes: IndexSet, to destination: Int) {
        classe.moveEleve(from: indexes, to: destination)
    }

    func delete(eleveIndex: Int) {
        ClasseManager().retirer(eleveIndex : eleveIndex,
                                deClasse   : &classe,
                                eleveStore : eleveStore)
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
                            isNew     : true,
                            isModified: .constant(false))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDisplayName("NewClasse")

            NavigationView {
                EmptyView()
                ClassDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                            isEditing : false,
                            isNew     : false,
                            isModified: .constant(false))
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDisplayName("DisplayClasse")
        }
    }
}
