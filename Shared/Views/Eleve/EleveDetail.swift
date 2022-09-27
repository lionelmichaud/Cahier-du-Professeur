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
    @State
    private var bonusIsExpanded = false
    @State
    private var showTrombine = false
    @State
    private var hasPAP = false

    @Preference(\.eleveAppreciationEnabled)
    var eleveAppreciationEnabled
    @Preference(\.eleveAnnotationEnabled)
    var eleveAnnotationEnabled
    @Preference(\.eleveBonusEnabled)
    var eleveBonusEnabled
    @Preference(\.maxBonusMalus)
    var maxBonusMalus
    @Preference(\.maxBonusIncrement)
    var maxBonusIncrement
    @Preference(\.eleveTrombineEnabled)
    var eleveTrombineEnabled

    var name: some View {
        HStack {
            if isNew || isEditing {
                HStack {
                    Image(systemName: "person.fill")
                        .sfSymbolStyling()
                        .foregroundColor(eleve.sexe.color)
                    // Sexe de cet eleve
                    CasePicker(pickedCase: $eleve.sexe, label: "Sexe")
                        .pickerStyle(.menu)
                    TextField("Prénom", text: $eleve.name.givenName.bound)
                        .onSubmit {
                            eleve.name.givenName.bound.trim()
                        }
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    TextField("Nom", text: $eleve.name.familyName.bound)
                        .onSubmit {
                            eleve.name.familyName.bound.trim()
                        }
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                }
            } else {
                EleveLabelWithTrombineFlag(eleve     : $eleve,
                                           isModified: $isModified,
                                           font      : .title2,
                                           fontWeight: .regular)
            }
        }
        .padding(.horizontal)
        .listRowSeparator(.hidden)
    }

    var bonus: some View {
        DisclosureGroup(isExpanded: $bonusIsExpanded) {
            Stepper(value : $eleve.bonus,
                    in    : -maxBonusMalus ... maxBonusMalus,
                    step  : maxBonusIncrement) {
                HStack {
                    Text(eleve.bonus >= 0 ? "Bonus" : "Malus")
                    Spacer()
                    Text("\(eleve.bonus.formatted(.number.precision(.fractionLength(2))))")
                        .foregroundColor(.secondary)
                }
            }
        } label: {
            Text("Bonus / Malus")
                .font(.headline)
                .fontWeight(.bold)
        }
        .listRowSeparator(.hidden)
        .onChange(of: eleve.bonus) {newValue in
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
                .swipeActions {
                    // supprimer un élève
                    Button(role: .destructive) {
                        withAnimation {
                            if let eleveId = observ.eleveId {
                                EleveManager().retirer(observId   : observ.id,
                                                       deEleveId  : eleveId,
                                                       eleveStore : eleveStore,
                                                       observStore: observStore)
                            }
                        }
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
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
                .swipeActions {
                    // supprimer un élève
                    Button(role: .destructive) {
                        withAnimation {
                            if let eleveId = colle.eleveId {
                                EleveManager().retirer(colleId    : colle.id,
                                                       deEleveId  : eleveId,
                                                       eleveStore : eleveStore,
                                                       colleStore : colleStore)
                            }
                        }
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
                }
            }
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
        VStack {
            // nom
            name

            List {
                if !isNew {
                    // appréciation sur l'élève
                    if eleveAppreciationEnabled {
                        AppreciationView(isExpanded  : $appreciationIsExpanded,
                                         isModified  : $isModified,
                                         appreciation: $eleve.appreciation)
                    }
                    // annotation sur l'élève
                    if eleveAnnotationEnabled {
                        AnnotationView(isExpanded: $noteIsExpanded,
                                       isModified: $isModified,
                                       annotation: $eleve.annotation)
                    }
                    // bonus/malus de l'élève
                    if eleveBonusEnabled {
                        bonus
                    }
                    // observations sur l'élève
                    observations
                    // colles de l'élève
                    colles
                }
            }
        }
        //.listStyle(.sidebar)
        #if os(iOS)
        .navigationTitle("Élève")
        //.navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            appreciationIsExpanded = eleve.appreciation.isNotEmpty
            noteIsExpanded         = eleve.annotation.isNotEmpty
            bonusIsExpanded        = (eleve.bonus != 0)
            hasPAP                 = eleve.troubleDys != nil
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

    // MARK: - Methods

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
