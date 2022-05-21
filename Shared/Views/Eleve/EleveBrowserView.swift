//
//  EleveBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @State private var filterObservation = false
    @State private var filterColle       = false
    @State private var filterFlag        = false
    // filtrage par nom/prénom
    @State
    private var selectedEleve: Eleve?
    @State
    private var searchString: String = ""
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch

    var body: some View {
        List(selection: $selectedEleve) {
            if eleveStore.items.isEmpty {
                Text("Aucun élève")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.sortedSchools()) { $school in
                    if school.nbOfClasses != 0 {
                        Section {
                            // pour chaque Classe
                            EleveBrowserSchoolSubiew(school            : school,
                                                     filterObservation : filterObservation,
                                                     filterColle       : filterColle,
                                                     filterFlag        : filterFlag,
                                                     searchString      : searchString)
                        } header: {
                            Text(school.displayString)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        .searchable(text      : $searchString,
                    placement : .navigationBarDrawer(displayMode : .automatic),
                    prompt    : "Filtrer")
        .disableAutocorrection(true)
        .toolbar {
            ToolbarItemGroup(placement: .status) {
                Text("Filtrer")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 4)
                Toggle(isOn: $filterObservation.animation(),
                       label: {
                    Image(systemName: "magnifyingglass")
                })
                .toggleStyle(.button)
                .padding(.trailing, 4)

                Toggle(isOn: $filterColle.animation(),
                       label: {
                    Image(systemName: "lock")
                })
                .toggleStyle(.button)
                .padding(.trailing, 4)

                Toggle(isOn: $filterFlag.animation(),
                       label: {
                    Image(systemName: "flag")
                })
                .toggleStyle(.button)
            }
        }
        .navigationTitle("Les Élèves")
    }
}

struct EleveBrowserSchoolSubiew : View {
    let school            : School
    var filterObservation : Bool
    var filterColle       : Bool
    var filterFlag        : Bool
    let searchString      : String
    @State
    private var isClasseExpanded = true

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore

    var body: some View {
        ForEach(classeStore.sortedClasses(dans: school)) { $classe in
            // pour chaque Elève
            if filteredSortedEleves(dans: classe).isNotEmpty {
                DisclosureGroup {
                    ForEach(filteredSortedEleves(dans: classe)) { $eleve in
                        NavigationLink {
                            EleveEditor(classe            : .constant(classe),
                                        eleve             : $eleve,
                                        isNew             : false,
                                        filterObservation : filterObservation,
                                        filterColle       : filterColle)
                        } label: {
                            EleveBrowserRow(eleve: eleve)
                        }
                        .swipeActions {
                            // supprimer un élève
                            Button(role: .destructive) {
                                withAnimation {
                                    // supprimer l'élève et tous ses descendants
                                    // puis retirer l'élève de la classe auquelle il appartient
                                    ClasseManager().retirer(eleve       : eleve,
                                                            deClasse    : &classe,
                                                            eleveStore  : eleveStore,
                                                            observStore : observStore,
                                                            colleStore  : colleStore)
                                }
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }

                            // flager un élève
                            Button {
                                withAnimation {
                                    eleve.isFlagged.toggle()
                                }
                            } label: {
                                if eleve.isFlagged {
                                    Label("Sans drapeau", systemImage: "flag.slash")
                                } else {
                                    Label("Avec drapeau", systemImage: "flag.fill")
                                }
                            }.tint(.orange)
                        }
                    }
                } label: {
                    Text(classe.displayString)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                }
            }
        }
    }

    // MARK: - Methods

    func filteredSortedEleves(dans classe: Classe) -> Binding<[Eleve]> {
        EleveManager().filteredEleves(dans              : classe,
                                            eleveStore        : eleveStore,
                                            observStore       : observStore,
                                            colleStore        : colleStore,
                                            filterObservation : filterObservation,
                                            filterColle       : filterColle,
                                            filterFlag        : filterFlag,
                                            searchString      : searchString)
    }
}

struct EleveBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EleveBrowserView()
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
    }
}
