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
    @FocusState
    private var isPrenomFocused: Bool

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
                        .focused($isPrenomFocused)
                    TextField("Nom", text: $eleve.name.familyName.bound)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(eleve.displayName)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .listRowSeparator(.hidden)

            // appréciation de l'élève
            if !isNew {
                VStack(alignment: .leading) {
                    Text("Appréciation")
                        .font(.title3)
                        .fontWeight(.bold)
                    TextEditor(text: $eleve.appreciation)
                        .multilineTextAlignment(.leading)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                        .frame(minHeight: 80)
                }
                .onChange(of: eleve.appreciation) {newValue in
                    isModified = true
                }
            }

            // observations de l'élève
            if !isNew {
                // titre
                HStack {
                    Text("Observations")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    // ajouter une observation
                    Button {
                        isModified        = true
                        newObserv         = Observation()
                        isAddingNewObserv = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .buttonStyle(.borderless)
                }

                // édition de la liste des observations
                ForEach(observStore.observations(de: eleve)) { $observ in
                    NavigationLink {
                        ObservEditor(eleve  : $eleve,
                                     observ : $observ,
                                     isNew  : false)
                    } label: {
                        EleveObservRow(observ: observ)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        isModified = true
                        deleteObserv(index: index)
                    }
                })
            }

            // colles de l'élève
            if !isNew {
                // titre
                HStack {
                    Text("Colles")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    // ajouter une colle
                    Button {
                        isModified       = true
                        newColle         = Colle()
                        isAddingNewColle = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .buttonStyle(.borderless)
                }

                // édition de la liste des colles
                ForEach(colleStore.colles(de: eleve)) { $colle in
                    NavigationLink {
                        ColleEditor(eleve : $eleve,
                                    colle : $colle,
                                    isNew : false)
                    } label: {
                        EleveColleRow(colle: colle)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        isModified = true
                        deleteColle(index: index)
                    }
                })
            }
        }
        #if os(iOS)
        .navigationTitle("Élève")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            isPrenomFocused = isNew
        }
        .sheet(isPresented: $isAddingNewObserv) {
            NavigationView {
                ObservEditor(eleve  : $eleve,
                             observ : $newObserv,
                             isNew  : true)
            }
        }
        .sheet(isPresented: $isAddingNewColle) {
            NavigationView {
                ColleEditor(eleve : $eleve,
                            colle : $newColle,
                            isNew : true)
            }
        }
    }

    func deleteObserv(index: Int) {
        EleveManager().retirer(observIndex : index,
                               deEleve     : &eleve,
                               observStore : observStore)
    }

    func deleteColle(index: Int) {
        EleveManager().retirer(colleIndex : index,
                               deEleve    : &eleve,
                               colleStore : colleStore)
    }
}

struct EleveDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                //EmptyView()
                EleveDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                            isEditing  : false,
                            isNew      : true,
                            isModified : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs Pro")
            .previewDisplayName("New Classe")

            NavigationView {
                //EmptyView()
                EleveDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                            isEditing  : false,
                            isNew      : false,
                            isModified : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
            .previewDisplayName("Display Classe")
        }
    }
}
