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
    var eleve: Eleve

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    // true si le mode édition est engagé
    @State
    private var isEditing = false
    @State
    private var isAddingNewObserv = false
    @State
    private var isAddingNewColle  = false
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
    private var eleveAppreciationEnabled
    @Preference(\.eleveAnnotationEnabled)
    private var eleveAnnotationEnabled
    @Preference(\.eleveBonusEnabled)
    private var eleveBonusEnabled
    @Preference(\.maxBonusMalus)
    private var maxBonusMalus
    @Preference(\.maxBonusIncrement)
    private var maxBonusIncrement
    @Preference(\.eleveTrombineEnabled)
    private var eleveTrombineEnabled
    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    // MARK: - Computed properties

    private var filterObservation : Bool {
        navigationModel.filterObservation
    }
    private var filterColle : Bool {
        navigationModel.filterColle
    }

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

    private var name: some View {
        GroupBox {
            if isEditing {
                ViewThatFits(in: .horizontal) {
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
        .padding(.horizontal)
        .listRowSeparator(.hidden)
    }

    private var bonus: some View {
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
    }

    private var observations: some View {
        Section {
            // édition de la liste des observations
            ForEach(observStore.sortedObservations(de          : eleve,
                                                   isConsignee : filterObservation ? false : nil,
                                                   isVerified  : filterObservation ? false : nil)) { $observ in
                EleveObservRow(observ: observ)
                    .onTapGesture {
                        // Programatic Navigation
                        navigationModel.selectedTab      = .observation
                        navigationModel.selectedObservId = observ.id
                    }
                    .swipeActions {
                        // supprimer un élève
                        Button(role: .destructive) {
                            withAnimation {
                                if let eleveId = observ.eleveId {
                                    if observ.id == navigationModel.selectedObservId {
                                        navigationModel.selectedObservId = nil
                                    }
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

    private var colles: some View {
        Section {
            // édition de la liste des colles
            ForEach(colleStore.sortedColles(de          : eleve,
                                            isConsignee : filterColle ? false : nil)) { $colle in
                EleveColleRow(colle: colle)
                    .onTapGesture {
                        // Programatic Navigation
                        navigationModel.selectedTab     = .colle
                        navigationModel.selectedColleId = colle.id
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
                // appréciation sur l'élève
                if eleveAppreciationEnabled {
                    AppreciationView(isExpanded  : $appreciationIsExpanded,
                                     appreciation: $eleve.appreciation)
                }
                // annotation sur l'élève
                if eleveAnnotationEnabled {
                    AnnotationView(isExpanded: $noteIsExpanded,
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
        .toolbar {
            ToolbarItem {
                Button {
                    // Appliquer les modifications faites à l'élève
                    if isEditing {
                        // supprimer les caractères blancs au début et à la fin
                        if eleve.name.familyName != nil {
                            eleve.name.familyName = eleve.name.familyName!.trimmed.uppercased()
                        }
                        if eleve.name.givenName != nil {
                            eleve.name.givenName!.trim()
                        }
                    }
                    withAnimation {
                        isEditing.toggle()
                    }
                } label: {
                    Text(isEditing ? "Ok" : "Modifier")
                }
            }
        }
        //.listStyle(.sidebar)
        #if os(iOS)
        .navigationTitle("Élève")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            appreciationIsExpanded = eleve.appreciation.isNotEmpty
            noteIsExpanded         = eleve.annotation.isNotEmpty
            bonusIsExpanded        = (eleve.bonus != 0)
            hasPAP                 = eleve.troubleDys != nil
        }
        .sheet(isPresented: $isAddingNewObserv) {
            NavigationView {
                ObservCreator(eleve: $eleve)
            }
        }
        .sheet(isPresented: $isAddingNewColle) {
            NavigationView {
                ColleCreator(eleve: $eleve)
            }
        }
    }

    // MARK: - Methods

    private func deleteObserv(index: Int) {
        EleveManager().retirer(observIndex : index,
                               deEleve     : &eleve,
                               observStore : observStore)
    }

    private func deleteColle(index: Int) {
        EleveManager().retirer(colleIndex : index,
                               deEleve    : &eleve,
                               colleStore : colleStore)
    }
}

struct EleveDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            //EmptyView()
            NavigationStack {
                EleveDetail(eleve: .constant(TestEnvir.eleveStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                EleveDetail(eleve: .constant(TestEnvir.eleveStore.items.first!))
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
