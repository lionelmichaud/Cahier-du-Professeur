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
    @State private var filterColle  = false

    var body: some View {
        List {
            if eleveStore.items.isEmpty {
                Text("Aucun élève")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.items.sorted(by: { $0.niveau.rawValue < $1.niveau.rawValue })) { school in
                    if school.nbOfClasses != 0 {
                        Section() {
                            // pour chaque Classe
                            EleveBrowserSchoolSubiew(school            : school,
                                                     filterObservation : filterObservation,
                                                     filterColle       : filterColle)
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
            }
        }
        .navigationTitle("Les Élèves")
    }
}

struct EleveBrowserSchoolSubiew : View {
    let school            : School
    var filterObservation : Bool
    var filterColle       : Bool

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore

    func filteredSortedEleves(dans classe: Classe) -> Binding<[Eleve]> {
        eleveStore.filteredSortedEleves(dans: classe) { eleve in

            lazy var nbObservWithActionToDo : Int = {
                EleveManager().nbOfObservations(de          : eleve,
                                                isConsignee : false,
                                                isVerified  : false,
                                                observStore : observStore)
            }()
            lazy var nbColleWithActionToDo : Int = {
                EleveManager().nbOfColles(de          : eleve,
                                          isConsignee : false,
                                          colleStore  : colleStore)
            }()

            switch (filterObservation, filterColle) {
                case (false, false):
                    // on ne filtre pas
                    return true

                case (true, false):
                    return nbObservWithActionToDo > 0

                case (false, true):
                    return nbColleWithActionToDo > 0

                case (true, true):
                    return nbObservWithActionToDo + nbColleWithActionToDo > 0
            }
        }
    }

    var body: some View {
        ForEach(classeStore.sortedClasses(dans: school)) { $classe in
            // pour chaque Elève
            if filteredSortedEleves(dans: classe).isNotEmpty {
                DisclosureGroup() {
                    ForEach(filteredSortedEleves(dans: classe)) { $eleve in
                        NavigationLink {
                            EleveEditor(classe : .constant(classe),
                                        eleve  : $eleve,
                                        isNew  : false)
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
