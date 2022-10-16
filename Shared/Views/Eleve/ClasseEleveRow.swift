//
//  ClasseEleveRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/04/2022.
//

import SwiftUI

struct ClasseEleveRow: View {
    let eleve: Eleve

    private var short: some View {
        HStack {
            EleveLabel(eleve: eleve)

            Spacer()

            EleveColleLabel(eleve: eleve, scale: .medium)
            EleveObservLabel(eleve: eleve, scale: .medium)
        }
    }

    private var long: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                // nom
                HStack {
                    EleveLabel(eleve: eleve)
                    Spacer()
                    Divider()
                }
                .frame(width: geometry.size.width * 0.43)

                // temps additionnel
                if let dys = eleve.troubleDys, dys.additionalTime {
                    HStack {
                        Text("1/3 de temps additionnel")
                        Spacer()
                        Divider()
                    }
                    .frame(width: geometry.size.width * 0.28)
                } else {
                    HStack {
                        EmptyView()
                        Spacer()
                        Divider()
                    }
                    .frame(width: geometry.size.width * 0.28)
                }

                // bonus
                if eleve.bonus != 0 {
                    HStack {
                        Text("Bonus:")
                        Spacer()
                        Text("\(eleve.bonus>0 ? "+" : "")\(eleve.bonus.formatted(.number.precision(.fractionLength(0))))")
                        Divider()
                    }
                    .frame(width: geometry.size.width * 0.14)
                } else {
                    HStack {
                        EmptyView()
                        Spacer()
                        Divider()
                    }
                    .frame(width: geometry.size.width * 0.14)
                }

                Spacer()

                EleveColleLabel(eleve: eleve, scale: .medium)
                EleveObservLabel(eleve: eleve, scale: .medium)
            }
        }
    }

    var body: some View {
        ViewThatFits(in: [.horizontal]) {
            // de préférence
            long
            // s'il n'y pas assez de place
            short
        }
    }
}

struct ClasseEleveRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                ClasseEleveRow(eleve: TestEnvir.eleveStore.items.first!)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")
            
            List {
                ClasseEleveRow(eleve: TestEnvir.eleveStore.items.first!)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
