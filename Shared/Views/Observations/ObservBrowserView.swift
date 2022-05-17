//
//  ObservBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/04/2022.
//

import SwiftUI

struct ObservBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var observStore : ObservationStore
    @State private var filterObservation = true

    var body: some View {
        List {
            if observStore.items.isEmpty {
                Text("Aucune observation")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.sortedSchools()) { $school in
                    if school.nbOfClasses != 0 {
                        Section() {
                            // pour chaque Classe
                            ObservBrowserSchoolSubiew(school            : school,
                                                      filterObservation : filterObservation)
                        } header: {
                            Text(school.displayString)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                        }
                    } else {
                        Text("Aucune classe dans cet établissement")
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
                    Text("Action")
                })
                .toggleStyle(.button)
            }
        }
        .navigationTitle("Les Observations")
    }
}

struct ObservBrowserSchoolSubiew : View {
    let school            : School
    var filterObservation : Bool
    @State private var isClasseExpanded = true

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var observStore : ObservationStore

    var body: some View {
        ForEach(classeStore.sortedClasses(dans: school)) { $classe in
            // pour chaque Elève
            if filteredSortedObservs(dans: classe).isNotEmpty {
                DisclosureGroup(isExpanded: $isClasseExpanded) {
                    ForEach(filteredSortedObservs(dans: classe)) { $observ in
                        NavigationLink {
                            ObservEditor(classe            : classe,
                                         eleve             : .constant(eleveStore.item(withID: observ.eleveId!)!),
                                         observ            : $observ,
                                         isNew             : false,
                                         filterObservation : filterObservation)
                        } label: {
                            ObservBrowserRow(eleve  : eleveStore.item(withID: observ.eleveId!)!,
                                             observ : observ)
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

    func filteredSortedObservs(dans classe: Classe) -> Binding<[Observation]> {
        eleveStore.filteredSortedObservations(dans        : classe,
                                              observStore : observStore) { observ in
            switch filterObservation {
                case false:
                    // on ne filtre pas
                    return true

                case true:
                    return observ.satisfies(isConsignee: false,
                                            isVerified : false)
            }
        }
    }
}

struct ObservBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        ObservBrowserView()
    }
}
