//
//  EleveDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI
import HelpersView

struct EleveDetail: View {
    @Binding
    var eleve     : Eleve
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewObserv = false
    @State
    private var isAddingNewColle  = false
    @State
    private var newObserv = Observation.exemple
    @State
    private var newColle  = Colle.exemple

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: "person.fill")
                    .sfSymbolStyling()
                    .foregroundColor(eleve.sexe.color)

                // Sexe de cet eleve
                if isNew || isEditing {
                    CasePicker(pickedCase: $eleve.sexe, label: "Sexe")
                        .pickerStyle(.menu)
                    TextField("Prénom", text: $eleve.name.givenName.bound)
                        .textFieldStyle(.roundedBorder)
                    TextField("Nom", text: $eleve.name.familyName.bound)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(eleve.displayName)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .listRowSeparator(.hidden)

            // observations de l'élève
            if !isNew {
                // titre
                //                Text(eleve.elevesLabel)
                //                    .font(.title3)
                //                    .fontWeight(.bold)
                //
                //                // édition de la liste des élèves
                //                ForEach(eleve.elevesID, id: \.self) { eleveId in
                //                    if let eleve = eleveStore.eleve(withID: eleveId) {
                //                        ClasseEleveRow(eleve: eleve)
                //                    } else {
                //                        Text("élève non trouvé: \(eleveId)")
                //                    }
                //                }
                //                .onDelete(perform: { indexSet in
                //                    for index in indexSet {
                //                        isModified = true
                //                        delete(eleveIndex: index)
                //                    }
                //                })
                //                .onMove(perform: moveEleve)
                //
                //                // ajouter un élève
                //                Button {
                //                    isModified = true
                //                    newEleve = Eleve.exemple
                //                    isAddingNewEleve = true
                //                } label: {
                //                    HStack {
                //                        Image(systemName: "plus")
                //                        Text("Ajouter un élève")
                //                    }
                //                }
                //                .buttonStyle(.borderless)
                EmptyView()
            }
        }
        #if os(iOS)
        .navigationTitle("Élève")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            //isHoursFocused = isNew
        }
        .sheet(isPresented: $isAddingNewObserv) {
            NavigationView {
                Text("Observations")
                //                EleveEditor(eleve : $eleve,
                //                            eleve  : $newEleve,
                //                            isNew  : true)
            }
        }
        .sheet(isPresented: $isAddingNewColle) {
            NavigationView {
                Text("Colles")
                //                EleveEditor(eleve : $eleve,
                //                            eleve  : $newEleve,
                //                            isNew  : true)
            }
        }
    }

    //    private func moveEleve(from indexes: IndexSet, to destination: Int) {
    //        eleve.moveEleve(from: indexes, to: destination)
    //    }
    //
    //    func delete(eleveIndex: Int) {
    //        ClasseManager().retirer(eleveIndex : eleveIndex,
    //                                deClasse   : &eleve,
    //                                eleveStore : eleveStore)
    //    }
}

struct EleveDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                EleveDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                            isEditing  : false,
                            isNew      : true,
                            isModified : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDisplayName("NewClasse")
        }
    }
}
