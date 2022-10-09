//
//  ColleBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/05/2022.
//

import SwiftUI

struct ColleSidebarView: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var schoolStore     : SchoolStore
    @EnvironmentObject private var colleStore      : ColleStore
    @State private var filterColle = true

    var body: some View {
        List(selection: $navigationModel.selectedColleId) {
            if colleStore.items.isEmpty {
                Text("Aucune colle actuellement")
            } else {
                /// pour chaque Etablissement
                ForEach(schoolStore.sortedSchools()) { school in
                    if school.nbOfClasses != 0 {
                        Section {
                            /// pour chaque Classe
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
                Toggle(isOn: $filterColle.animation(),
                       label: {
                    Text("A faire")
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

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var classeStore     : ClasseStore
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore

    var body: some View {
        ForEach(classeStore.sortedClasses(dans: school)) { classe in
            if someColles(dans: classe) {
                DisclosureGroup(isExpanded: .constant(true)) {
                    /// pour chaque Elève
                    ForEach(filteredSortedColles(dans: classe)) { colle in
                        /// pour chaque Colle
                        if let eleveId = colle.eleveId,
                           let eleve = eleveStore.item(withID: eleveId) {
                            ColleBrowserRow(eleve : eleve,
                                            colle : colle)
                            .swipeActions {
                                // supprimer un élève
                                Button(role: .destructive) {
                                    withAnimation {
                                        if let eleveId = colle.eleveId {
                                            if colle.id == navigationModel.selectedColleId {
                                                navigationModel.selectedColleId = nil
                                            }
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

    private func someColles(dans classe : Classe) -> Bool {
        eleveStore.someColles(dans        : classe,
                              colleStore  : colleStore,
                              isConsignee : filterColle ? false : nil)
    }

    private func filteredSortedColles(dans classe: Classe) -> [Colle] {
        eleveStore.filteredSortedColles(dans        : classe,
                                        colleStore  : colleStore,
                                        isConsignee : filterColle ? false : nil)
    }
}

struct ColleBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ColleSidebarView()
                .environmentObject(NavigationModel(selectedColleId: TestEnvir.eleveStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
    }
}
