//
//  ColleBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI

struct ColleBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @State private var filterColle = true

    var body: some View {
        List {
            if colleStore.items.isEmpty {
                Text("Aucune colle")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.sortedSchools()) { $school in
                    if school.nbOfClasses != 0 {
                        Section() {
                            // pour chaque Classe
                            ColleBrowserSchoolSubiew(school      : school,
                                                     filterColle : filterColle)
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
                Toggle(isOn: $filterColle.animation(),
                       label: {
                    Image(systemName: "lock.fill")
                })
                .toggleStyle(.button)
            }
        }
        .navigationTitle("Les Colles")
    }
}

struct ColleBrowserSchoolSubiew : View {
    let school      : School
    var filterColle : Bool
    @State private var isClasseExpanded = true

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore

    var body: some View {
        ForEach(classeStore.sortedClasses(dans: school)) { $classe in
            // pour chaque Elève
            if filteredSortedColles(dans: classe).isNotEmpty {
                DisclosureGroup(isExpanded: $isClasseExpanded) {
                    ForEach(filteredSortedColles(dans: classe)) { $colle in
                        NavigationLink {
                            ColleEditor(classe      : classe,
                                        eleve       : .constant(Eleve.exemple),
                                        colle       : $colle,
                                        isNew       : false,
                                        filterColle : filterColle)
                        } label: {
                            ColleBrowserRow(eleve : eleveStore.eleve(withID: colle.eleveId!)!,
                                            colle : colle)
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

    func filteredSortedColles(dans classe: Classe) -> Binding<[Colle]> {
        eleveStore.filteredSortedColles(dans       : classe,
                                        colleStore : colleStore) { colle in
            switch filterColle {
                case false:
                    // on ne filtre pas
                    return true

                case true:
                    return colle.satisfies(isConsignee: false)
            }
        }
    }
}

struct ColleBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        ColleBrowserView()
    }
}
