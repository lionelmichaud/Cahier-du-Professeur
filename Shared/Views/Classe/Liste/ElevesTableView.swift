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
            Text(troubleDys.additionalTime ? "1/3 tps supplémentaire" : "")
        } else {
            EmptyView()
        }
    }

    var body: some View {
        Table(eleves, selection: $selection) {
            // nom
            TableColumn("Nom") { eleve in
                tappableName(eleve)
            }

            // temps additionel
            TableColumn("PAP") { eleve in
                tpsSup(eleve)
            }
            .width(200)

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
