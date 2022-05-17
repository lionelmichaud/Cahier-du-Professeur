//
//  EleveDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI
import HelpersView

struct EleveDetail: View {
    var classe            : Classe
    @Binding
    var eleve             : Eleve
    let isEditing         : Bool
    var isNew             : Bool
    var filterObservation : Bool
    var filterColle       : Bool
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
    @State
    private var appreciationIsExpanded = false
    @State
    private var noteIsExpanded = false
    @FocusState
    private var isPrenomFocused: Bool

    var name: some View {
        HStack {
            Image(systemName: "person.fill")
                .sfSymbolStyling()
                .foregroundColor(eleve.sexe.color)

            if isNew || isEditing {
                // Sexe de cet eleve
                CasePicker(pickedCase: $eleve.sexe, label: "Sexe")
                    .pickerStyle(.menu)
                TextField("Prénom", text: $eleve.name.givenName.bound)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .focused($isPrenomFocused)
                TextField("Nom", text: $eleve.name.familyName.bound)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
            } else {
                Text(eleve.displayName)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                Button {
                    eleve.isFlagged.toggle()
                } label: {
                    if eleve.isFlagged {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "flag")
                            .foregroundColor(.orange)
                    }
                }
                .onChange(of: eleve.isFlagged) {newValue in
                    isModified = true
                }
            }
        }
        .listRowSeparator(.hidden)
    }

    var appreciation: some View {
        DisclosureGroup(isExpanded: $appreciationIsExpanded) {
            TextEditor(text: $eleve.appreciation)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                .frame(minHeight: 80)
        } label: {
            Text("Appréciation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .onChange(of: eleve.appreciation) {newValue in
            isModified = true
        }
    }

    var annotation: some View {
        DisclosureGroup(isExpanded: $noteIsExpanded) {
            TextEditor(text: $eleve.annotation)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                .frame(minHeight: 80)
        } label: {
            Text("Annotation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .onChange(of: eleve.annotation) {newValue in
            isModified = true
        }
    }

    var observations: some View {
        Section {
            // édition de la liste des observations
            ForEach(observStore.sortedObservations(de          : eleve,
                                                   isConsignee : filterObservation ? false : nil,
                                                   isVerified  : filterObservation ? false : nil)) { $observ in
                NavigationLink {
                    ObservEditor(classe            : classe,
                                 eleve             : $eleve,
                                 observ            : $observ,
                                 isNew             : false,
                                 filterObservation : filterObservation)
                } label: {
                    EleveObservRow(observ: observ)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    isModified = true
                    deleteObserv(index: index)
                }
            }
        } header: {
            HStack {
                Text("Observations")
                    .font(.headline)
                Spacer()
                // ajouter une observation
                Button {
                    isModified        = true
                    newObserv         = Observation()
                    isAddingNewObserv = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                }
                .buttonStyle(.borderless)
            }
        }
        .headerProminence(.increased)
        //.font(.headline)
    }

    var colles: some View {
        Section {
            // édition de la liste des colles
            ForEach(colleStore.sortedColles(de          : eleve,
                                      isConsignee : filterColle ? false : nil)) { $colle in
                NavigationLink {
                    ColleEditor(classe      : classe,
                                eleve       : $eleve,
                                colle       : $colle,
                                isNew       : false,
                                filterColle : filterColle)
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
        } header: {
            HStack {
                Text("Colles")
                    .font(.headline)
                Spacer()
                // ajouter une colle
                Button {
                    isModified       = true
                    newColle         = Colle()
                    isAddingNewColle = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                }
                .buttonStyle(.borderless)
            }
        }
        .headerProminence(.increased)
        //.font(.headline)
    }

    var body: some View {
        List {
            // nom
            name

            if !isNew {
                // appréciation sur l'élève
                appreciation
                // annotation sur l'élève
                annotation
                // observations sur l'élève
                observations
                // colles de l'élève
                colles
            }
        }
        //.listStyle(.sidebar)
        #if os(iOS)
        .navigationTitle("Élève")
        //.navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            isPrenomFocused = isNew
            appreciationIsExpanded = eleve.appreciation.isNotEmpty
            noteIsExpanded = eleve.annotation.isNotEmpty
        }
        .sheet(isPresented: $isAddingNewObserv) {
            NavigationView {
                ObservEditor(classe            : classe,
                             eleve             : $eleve,
                             observ            : $newObserv,
                             isNew             : true,
                             filterObservation : false)
            }
        }
        .sheet(isPresented: $isAddingNewColle) {
            NavigationView {
                ColleEditor(classe      : classe,
                            eleve       : $eleve,
                            colle       : $newColle,
                            isNew       : true,
                            filterColle : false)
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
                EleveDetail(classe            : TestEnvir.classeStore.items.first!,
                            eleve             : .constant(TestEnvir.eleveStore.items.first!),
                            isEditing         : false,
                            isNew             : true,
                            filterObservation : false,
                            filterColle       : false,
                            isModified        : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs Pro")
            .previewDisplayName("New Classe")

            NavigationView {
                //EmptyView()
                EleveDetail(classe            : TestEnvir.classeStore.items.first!,
                            eleve             : .constant(TestEnvir.eleveStore.items.first!),
                            isEditing         : false,
                            isNew             : false,
                            filterObservation : false,
                            filterColle       : false,
                            isModified        : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
            .previewDisplayName("Display Classe")
        }
    }
}
