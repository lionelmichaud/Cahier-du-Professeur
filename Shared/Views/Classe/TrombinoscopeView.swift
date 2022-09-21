//
//  TrombinoscopeView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/09/2022.
//

import SwiftUI

struct TrombinoscopeView: View {
    @Binding
    var classe: Classe

    @EnvironmentObject
    var eleveStore  : EleveStore

    @Preference(\.nameDisplayOrder)
    var nameDisplayOrder

    let font       : Font        = .title3
    let fontWeight : Font.Weight = .semibold

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 120, maximum: 200))]
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns, spacing: 4, pinnedViews: .sectionFooters) {
                //                Section(footer: TrombinoscopeFooterVGridView(nbOfEleves: classe.nbOfEleves)) {
                ForEach(eleveStore.filteredEleves(dans: classe)) { $eleve in
                    VStack {
                        if let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                            // si le dossier Document existe
                            ZStack(alignment: .bottom) {
                                LoadableImage(imageUrl: trombine)
                                TrombinoscopeFooterView(eleve: $eleve)
                            }
                            Text(eleve.displayName2lines(nameDisplayOrder))
                                .multilineTextAlignment(.center)
                        }
                    }
                    //                    }
                }
            }
        }
        #if os(iOS)
        .navigationTitle(classe.displayString + " (\(classe.nbOfEleves) Élèves)")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct TrombinoscopeFooterView: View {
    @Binding var eleve: Eleve

    @Preference(\.maxBonusIncrement)
    var maxBonusIncrement

    var body: some View {
        HStack(spacing: 0) {
            Button(iconName: "minus.circle") {
                eleve.bonus -= maxBonusIncrement
            }
            .buttonStyle(.bordered)

            Spacer()
            if eleve.bonus != 0 {
                Text("\(eleve.bonus.formatted(.number.precision(.fractionLength(0))))")
                    .fontWeight(.bold)
                    .foregroundColor(eleve.bonus > 0 ? .green : .red)
                Spacer()
            }

            Button(iconName: "plus.circle") {
                eleve.bonus += maxBonusIncrement
            }
            .buttonStyle(.bordered)
        }
        .background(Rectangle().fill(Color.white).opacity(0.9))
    }
}

struct TrombinoscopeView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return TrombinoscopeView(classe: .constant(TestEnvir.classeStore.items.first!))
    }
}
