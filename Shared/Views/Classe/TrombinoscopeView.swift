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

    @State
    private var isAddingNewObserv = false
    @State
    private var isAddingNewColle  = false
    @State
    private var newObserv = Observation.exemple
    @State
    private var newColle  = Colle.exemple

    @Preference(\.nameDisplayOrder)
    var nameDisplayOrder

    let font       : Font        = .title3
    let fontWeight : Font.Weight = .semibold

    private var menu: some View {
        Menu {
            Button {
            } label: {
                Label("A propos", systemImage: "info.circle")
            }
            // ajouter une observation
            Button {
//                isModified        = true
                newObserv         = Observation()
                isAddingNewObserv = true
            } label: {
                Label("Nouvelle observation", systemImage: "rectangle.and.text.magnifyingglass")
            }
            // ajouter une colle
            Button {
//                isModified       = true
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
        let columns = [GridItem(.adaptive(minimum: 120, maximum: 200))]
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: columns, spacing: 4, pinnedViews: .sectionFooters) {
                ForEach(eleveStore.filteredEleves(dans: classe)) { $eleve in
                    if let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                        VStack {
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
                                            NavigationView {
                                                ObservEditor(eleve  : $eleve,
                                                             observ : $newObserv,
                                                             isNew  : true)
                                            }
                                        }
                                        .sheet(isPresented: $isAddingNewColle) {
                                            NavigationView {
                                                ColleEditor(classe : classe,
                                                            eleve  : $eleve,
                                                            colle  : $newColle,
                                                            isNew  : true)
                                            }
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

struct TrombinoscopeView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return TrombinoscopeView(classe: .constant(TestEnvir.classeStore.items.first!))
    }
}
