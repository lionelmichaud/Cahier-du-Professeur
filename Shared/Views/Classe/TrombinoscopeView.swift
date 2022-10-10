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

struct TrombineView : View {
    @Binding
    var eleve: Eleve

    @EnvironmentObject private var navigationModel : NavigationModel

    @State
    private var isAddingNewObserv = false
    @State
    private var isAddingNewColle  = false
    @State
    private var newObserv = Observation.exemple
    @State
    private var newColle  = Colle.exemple

    private var menu: some View {
        Menu {
            // aller à la fiche élève
            Button {
                // Programatic Navigation
                navigationModel.selectedTab     = .eleve
                navigationModel.selectedEleveId = eleve.id
            } label: {
                Label("Fiche élève", systemImage: "info.circle")
            }
            // ajouter une observation
            Button {
                newObserv         = Observation()
                isAddingNewObserv = true
            } label: {
                Label("Nouvelle observation", systemImage: "rectangle.and.text.magnifyingglass")
            }
            // ajouter une colle
            Button {
                newColle         = Colle()
                isAddingNewColle = true
            } label: {
                Label("Nouvelle colle", systemImage: "lock.fill")
            }

        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding(4)
        }
    }

    var body: some View {
        if let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                // si le dossier Document existe
                ZStack(alignment: .topLeading) {
                    ZStack(alignment: .topTrailing) {
                        ZStack(alignment: .bottom) {
                            LoadableImage(imageUrl: trombine)
                            /// Points +/-
                            TrombinoscopeFooterView(eleve: $eleve)
                        }
                        /// Coin supérieur droit: Menu
                        menu
                            .sheet(isPresented: $isAddingNewObserv) {
                                NavigationStack {
                                    ObservCreator(eleve: $eleve)
                                }
                                .presentationDetents([.medium])
                            }
                            .sheet(isPresented: $isAddingNewColle) {
                                NavigationStack {
                                    ColleCreator(eleve: $eleve)
                                }
                                .presentationDetents([.medium])
                            }
                    }

                    /// Coin supérieur gauche: Flag
                    Button {
                        eleve.isFlagged.toggle()
                    } label: {
                        if eleve.isFlagged {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.orange)
                        } else {
                            Image(systemName: "flag")
                                .foregroundColor(.orange)
                        }
                    }
                    .buttonStyle(.bordered)
                }
        }
    }
}

struct TrombinoscopeFooterView: View {
    @Binding var eleve: Eleve

    @Preference(\.maxBonusIncrement)
    var maxBonusIncrement

    var body: some View {
        HStack(spacing: 0) {
            Button(iconName: "hand.thumbsdown.fill") {
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

            Button(iconName: "hand.thumbsup.fill") {
                eleve.bonus += maxBonusIncrement
            }
            .buttonStyle(.bordered)
        }
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).opacity(0.8))
    }
}

struct TrombinoscopeFooterView_Previews: PreviewProvider {
    static var previews: some View {
        TrombinoscopeFooterView(eleve: .constant(Eleve.exemple))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Footer")
            //.previewDevice("iPhone 13")
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
