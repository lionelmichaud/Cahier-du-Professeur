//
//  GroupListView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 16/10/2022.
//

import SwiftUI

struct GroupListView : View {
    let group    : GroupOfEleves
    var classe   : Classe
    let isEditing: Bool

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @State
    private var isMovingEleve = false

    // MARK: - Compute Properties

    private var nbGroupInClasse: Int {
        GroupManager.largestGroupNumber(dans       : classe,
                                        eleveStore : eleveStore)
    }

    var body: some View {
        Group {
            if isEditing {
                /// ajouter un élève au groupe parmis ceux qui ne sont pas encore affectés
                Menu {
                    ForEach(GroupManager.unGroupedEleves(dans: classe, eleveStore: eleveStore), id: \.self) { eleveID in
                        Button {
                            if var eleve = eleveStore.item(withID: eleveID) {
                                eleve.group = group.number
                                eleveStore.update(with: eleve)
                            }
                        } label: {
                            Label((eleveStore.item(withID: eleveID)?.displayName(nameDisplayOrder))!, systemImage: "graduationcap")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter un élève")
                    }
                }
                .buttonStyle(.borderless)
            }

            /// pour chaque Elève
            ForEach(group.elevesID, id: \.self) { eleveID in
                if let eleve = eleveStore.itemBinding(withID: eleveID) {
                    EleveLabel(eleve: eleve.wrappedValue)
                        .onTapGesture {
                            /// Programatic Navigation
                            navigationModel.selectedTab     = .eleve
                            navigationModel.selectedEleveId = eleve.id
                        }
                        .swipeActions {
                            if isEditing {
                                /// retirer l'élève du groupe
                                Button(role: .destructive) {
                                    withAnimation {
                                        eleve.wrappedValue.group = nil
                                    }
                                } label: {
                                    Label("Retirer", systemImage: "person.fill.badge.minus")
                                }
                            }
                        }
                    // FIXME: Ne fonctionne pas
//                        .swipeActions {
//                            if isEditing {
//                                /// changer l'élève de groupe
//                                Button {
//                                    isMovingEleve = true
//                                } label: {
//                                    Label("Retirer", systemImage: "person.fill.badge.minus")
//                                }
//                            }
//                        }
                        .sheet(isPresented: $isMovingEleve) {
                            NavigationStack {
                                MoveEleveDialog(eleve : eleve, nbGroupInClasse: nbGroupInClasse)
                            }
                            .presentationDetents([.large])
                        }
                }
            }
        }
    }
}

// FIXME: Ne fonctionne pas
struct MoveEleveDialog : View {
    @Binding
    var eleve: Eleve

    let nbGroupInClasse : Int

    @Environment(\.dismiss)
    private var dismiss

    @State
    private var groupeNb : Int = 0

    @State
    private var grpTable = [Int]()

    // MARK: - Computed Properties

    private var grpRange: Range<Int> {
        1 ..< (nbGroupInClasse+1)
    }

    var body: some View {
        Form {
            Picker("Groupe", selection: $groupeNb) {
                ForEach(grpTable, id: \.self) { grp in
                    Label(String(grp), systemImage: "person.line.dotted.person.fill")
                }
            }
            .pickerStyle(.inline)
        }
        #if os(iOS)
        .navigationTitle("Déplacer vers")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Déplacer") {
                    withAnimation {
                        print("\(eleve.displayName) déplacé de \(String(describing: eleve.group)) vers \(groupeNb)")
                        eleve.group = groupeNb
                    }
                    dismiss()
                }
            }
        }
        .task {
            grpRange.forEach {
                grpTable.append($0)
            }
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                GroupListView(group      : TestEnvir.group,
                              classe     : TestEnvir.classeStore.items.first!,
                              isEditing : true)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            List {
                GroupListView(group     : TestEnvir.group,
                              classe    : TestEnvir.classeStore.items.first!,
                              isEditing : true)
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
