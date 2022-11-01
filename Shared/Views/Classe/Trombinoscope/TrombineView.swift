//
//  TrombineView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 17/10/2022.
//

import SwiftUI

struct TrombineView : View {
    @Binding
    var eleve: Eleve

    @EnvironmentObject private var navigationModel : NavigationModel

    @State
    private var isAddingNewObserv = false

    @State
    private var isAddingNewColle  = false

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
                isAddingNewObserv = true
            } label: {
                Label("Nouvelle observation", systemImage: "rectangle.and.text.magnifyingglass")
            }
            // ajouter une colle
            Button {
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
                        // TODO: - Gérer ici la mise à jour de la photo pastruct drag and drop : View {
                        LoadableImage(imageUrl: trombine,
                                      placeholderImage: .constant(Image(systemName: "person.fill.questionmark")))
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
