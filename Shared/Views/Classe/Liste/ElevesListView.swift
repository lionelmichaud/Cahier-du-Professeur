//
//  ElevesListView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 17/10/2022.
//

import SwiftUI

struct ElevesListView: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State
    private var isAddingNewEleve = false

    @State
    private var searchString: String = ""

    private var filteredEleves: Binding<[Eleve]> {
        eleveStore
            .filteredEleves(dans: classe) { eleve in
                if searchString.isNotEmpty {
                    if searchString.containsOnlyDigits {
                        // filtrage sur numéro de groupe
                        let groupNum = Int(searchString)!
                        return eleve.group == groupNum

                    } else {
                        let string = searchString.lowercased()
                        return eleve.name.familyName!.lowercased().contains(string) ||
                        eleve.name.givenName!.lowercased().contains(string)
                    }
                } else {
                    return true
                }
            }
    }

    var body: some View {
        List {
            /// ajouter un élève
            Button {
                isAddingNewEleve = true
            } label: {
                Label("Ajouter un élève", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderless)

            /// liste des élèves
            ForEach(filteredEleves) { $eleve in
                ClasseEleveRow(eleve: eleve)
                    .onTapGesture {
                        /// Programatic Navigation
                        navigationModel.selectedTab     = .eleve
                        navigationModel.selectedEleveId = eleve.id
                    }
                    .swipeActions {
                        /// supprimer un élève
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

                        /// flager un élève
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
        }
        .searchable(text      : $searchString,
                    placement : .navigationBarDrawer(displayMode : .automatic),
                    prompt    : "Nom, Prénom ou n° de groupe")
        .autocorrectionDisabled()
        #if os(iOS)
        .navigationTitle("Liste " + classe.displayString + " (\(classe.nbOfEleves))")
        #endif
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationStack {
                EleveCreator(classe: $classe)
            }
            .presentationDetents([.medium])
        }
    }
}

struct ElevesListView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ElevesListView(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
                .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ElevesListView(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
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
