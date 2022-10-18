//
//  ElevesTableView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 17/10/2022.
//

import SwiftUI

struct ElevesTableView: View {
    @Binding var classe: Classe

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State private var isAddingNewEleve = false

    @State private var selection: Set<Eleve.ID> = []

    private var eleves: [Eleve] {
        eleveStore.filteredEleves(dans: classe)
    }

    @ViewBuilder
    private func tappableName(_ eleve: Eleve) -> some View {
        EleveLabel(eleve: eleve)
            .onTapGesture {
                /// Programatic Navigation
                navigationModel.selectedTab     = .eleve
                navigationModel.selectedEleveId = eleve.id
            }
    }

    @ViewBuilder
    private func bonus(_ eleve: Eleve) -> some View {
        if eleve.bonus.isNotZero {
            Text("\(eleve.bonus.isPositive ? "+" : "")\(eleve.bonus.formatted(.number.precision(.fractionLength(0))))")
                .foregroundColor(eleve.bonus.isPositive ? .green : .red)
                .fontWeight(.semibold)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func tpsSup(_ eleve: Eleve) -> some View {
        if let troubleDys = eleve.troubleDys {
            Text(troubleDys.additionalTime ? "1/3 tps en +" : "")
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func groupe(_ eleve: Eleve) -> some View {
        if let group = eleve.group {
            Text("\(group)")
        } else {
            EmptyView()
        }
    }

   var body: some View {
        VStack {
            Table(eleves, selection: $selection) {
                // nom
                TableColumn("Nom") { eleve in
                    tappableName(eleve)
                }

                // groupe
                TableColumn("Groupe") { eleve in
                    groupe(eleve)
                }
                .width(100)

                // temps additionel
                TableColumn("PAP") { eleve in
                    tpsSup(eleve)
                }
                .width(100)

                // bonus / malus
                TableColumn("Bonus") { eleve in
                    bonus(eleve)
                }
                .width(100)

                // colles
                TableColumn("Colles") { eleve in
                    EleveColleLabel(eleve: eleve, scale: .medium)
                }
                .width(50)

                // observations
                TableColumn("Obs") { eleve in
                    EleveObservLabel(eleve: eleve, scale: .medium)
                }
                .width(50)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                /// supprimer des élèves
                Button(role: .destructive) {
                    withAnimation {
                        selection.forEach { eleveId in
                            if let eleve = eleveStore.item(withID: eleveId) {
                                // supprimer l'élève et tous ses descendants
                                // puis retirer l'élève de la classe auquelle il appartient
                                ClasseManager().retirer(eleve       : eleve,
                                                        deClasse    : &classe,
                                                        eleveStore  : eleveStore,
                                                        observStore : observStore,
                                                        colleStore  : colleStore)
                            }
                        }
                    }
                } label: {
                    Label("Supprimer", systemImage: "trash")
                }
                .disabled(selection.count == 0)

                /// ajouter un élève
                Button {
                    isAddingNewEleve = true
                } label: {
                    Label("Ajouter", systemImage: "plus.circle.fill")
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Élèves de " + classe.displayString + " (\(classe.nbOfEleves))")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationStack {
                EleveCreator(classe: $classe)
            }
            .presentationDetents([.medium])
        }
    }
}

struct ElevesTableView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ElevesTableView(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ElevesTableView(classe: .constant(TestEnvir.classeStore.items.first!))
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
