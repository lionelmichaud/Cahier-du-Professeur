//
//  ClassRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/04/2022.
//

import SwiftUI
import HelpersView

struct ClassBrowserRow: View {
    let classe: Classe

    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(classe.displayString)
                        .fontWeight(.bold)
                    Spacer()
                    ClasseColleLabel(classe: classe, scale: .large)
                    ClasseObservLabel(classe: classe, scale: .large)
                }

                HStack {
                    Text("\(classe.nbOfEleves) élèves")
                    Spacer()
                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) heures")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}

struct ClassRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClassBrowserRow(classe: TestEnvir.classeStore.items.first!)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.observStore)
                .environmentObject(TestEnvir.colleStore)
                .previewLayout(.sizeThatFits)
        }
    }
}
