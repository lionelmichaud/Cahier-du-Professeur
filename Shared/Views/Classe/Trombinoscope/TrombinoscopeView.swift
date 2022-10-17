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

    @EnvironmentObject private var eleveStore: EleveStore

    let smallColumns = [GridItem(.adaptive(minimum: 120, maximum: 200))]
    let largeColumns = [GridItem(.adaptive(minimum: 180, maximum: 300))]

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    let font       : Font        = .title3
    let fontWeight : Font.Weight = .semibold

    @State
    private var pictureSize = "Small picture"

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: pictureSize == "Small picture" ? smallColumns : largeColumns,
                      spacing: 4) {
                ForEach(eleveStore.filteredEleves(dans: classe)) { $eleve in
                    VStack {
                        TrombineView(eleve: $eleve)

                        /// Nom de l'élève
                        if eleve.troubleDys == nil {
                            Text(eleve.displayName2lines(nameDisplayOrder))
                                .multilineTextAlignment(.center)
                                .fontWeight(fontWeight)
                        } else {
                            Text(eleve.displayName2lines(nameDisplayOrder))
                                .multilineTextAlignment(.center)
                                .fontWeight(fontWeight)
                                .padding(2)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.gray)
                                }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Picker("Présentation", selection: $pictureSize.animation()) {
                    Image(systemName: "minus.magnifyingglass").tag("Small picture")
                    Image(systemName: "plus.magnifyingglass").tag("Largepicture")
                }
                .pickerStyle(.segmented)
            }
        }
        #if os(iOS)
        .navigationTitle(classe.displayString + " (\(classe.nbOfEleves) élèves)")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct TrombinoscopeView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                TrombinoscopeView(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                TrombinoscopeView(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel())
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
