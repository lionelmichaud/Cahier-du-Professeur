//
//  GroupsView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 24/09/2022.
//

import SwiftUI
import AppFoundation

struct GroupsView: View {
    @Binding
    var classe: Classe

    enum ViewMode: Int {
        case list
        case picture
    }

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @EnvironmentObject var eleveStore: EleveStore

    @State
    private var isShowingDeleteGroupsDialog = false

    @State
    private var expanded = true

    @State
    private var isEditing = false

    @State
    private var searchString: String = ""

    @State
    private var groups = [GroupOfEleves]()

    @State
    private var ungrouped = GroupOfEleves(number: 0)

    @State
    private var presentation: ViewMode = .list

    private var toolbarMenu: some View {
        Menu {
            /// Générer les groupes
            Menu {
                Menu {
                    Button("2 élèves") {
                        withAnimation {
                            GroupManager.formOrderedGroups(nbEleveParGroupe : 2,
                                                           dans             : classe,
                                                           eleveStore       : eleveStore)
                            updateGroups()

                        }
                    }
                    Button("3 élèves") {
                        withAnimation {
                            GroupManager.formOrderedGroups(nbEleveParGroupe: 3,
                                                           dans             : classe,
                                                           eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                    Button("4 élèves") {
                        withAnimation {
                            GroupManager.formOrderedGroups(nbEleveParGroupe: 4,
                                                           dans             : classe,
                                                           eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                    Button("5 élèves") {
                        withAnimation {
                            GroupManager.formOrderedGroups(nbEleveParGroupe: 5,
                                                           dans             : classe,
                                                           eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                } label: {
                    Label("Par ordre alphabétique", systemImage: "textformat.size.larger")
                }

                Menu {
                    Button("2 élèves") {
                        withAnimation {
                            GroupManager.formRandomGroups(nbEleveParGroupe: 2,
                                                          dans             : classe,
                                                          eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                    Button("3 élèves") {
                        withAnimation {
                            GroupManager.formRandomGroups(nbEleveParGroupe: 3,
                                                          dans             : classe,
                                                          eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                    Button("4 élèves") {
                        withAnimation {
                            GroupManager.formRandomGroups(nbEleveParGroupe: 4,
                                                          dans             : classe,
                                                          eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                    Button("5 élèves") {
                        withAnimation {
                            GroupManager.formRandomGroups(nbEleveParGroupe: 5,
                                                          dans             : classe,
                                                          eleveStore       : eleveStore)
                            updateGroups()
                        }
                    }
                } label: {
                    Label("Aléatoirement", systemImage: "die.face.5")
                }

            } label: {
                Label("Générer les groupes", systemImage: "person.line.dotted.person.fill")
            }

            /// Modifier les groupes
            if presentation == .list {
                Button {
                    withAnimation {
                        isEditing.toggle()
                    }
                } label: {
                    Label(isEditing ? "Valider les modifications" : "Modifier les groupes",
                          systemImage: isEditing ? "checkmark" : "pencil")
                }
            }

            /// Supprimer les groupes
            Button(role: .destructive) {
                isShowingDeleteGroupsDialog.toggle()
            } label: {
                Label("Suprimer les groupes", systemImage: "trash")
            }

        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding(4)
        }
    }

    private var ungroupedEleves: some View {
        Group {
            if !ungrouped.isEmpty {
                DisclosureGroup(isExpanded: $expanded) {
                    switch presentation {
                        case .list:
                            GroupListView(group    : ungrouped,
                                          classe   : classe,
                                          isEditing: isEditing)
                        case .picture:
                            GroupPicturesView(group: ungrouped)
                    }
                } label: {
                    Text("Sans groupe")
                        .foregroundColor(.red)
                }
            } else {
                EmptyView()
            }
        }
    }

    var body: some View {
        Group {
            if groups.count == 0 {
                VStack(alignment: .center, spacing: 10) {
                    Text("Aucun groupe.")
                    Text("Créer des groupes.")
                }

            } else {
                List {
                    /// pour chaque Groupe
                    ForEach(GroupManager.groups(dans       : classe,
                                                including  : searchString,
                                                eleveStore : eleveStore)) { group in
                        DisclosureGroup(isExpanded: $expanded) {
                            switch presentation {
                                case .list:
                                    GroupListView(group    : group,
                                                  classe   : classe,
                                                  isEditing: isEditing)
                                case .picture:
                                    GroupPicturesView(group: group)
                            }
                        } label: {
                            Text("Groupe \(group.number.formatted())")
                                .foregroundColor(.secondary)
                        }
                    }
                    ungroupedEleves
                }
                .searchable(text      : $searchString,
                            placement : .navigationBarDrawer(displayMode : .automatic),
                            prompt    : "Nom ou Prénom de l'élève")
                .autocorrectionDisabled()
            }
        }
        #if os(iOS)
        .navigationTitle("Groupes " + classe.displayString + " (\(classe.nbOfEleves))")
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Picker("Présentation", selection: $presentation) {
                    Image(systemName: "list.bullet").tag(ViewMode.list)
                    Image(systemName: "person.crop.square.fill").tag(ViewMode.picture)
                }
                .pickerStyle(.segmented)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                toolbarMenu
                /// Confirmation de suppresssion de tous les groupes
                .confirmationDialog(
                    "Supression de tous les groupes",
                    isPresented     : $isShowingDeleteGroupsDialog,
                    titleVisibility : .visible) {
                        Button("Supprimer", role: .destructive) {
                            withAnimation {
                                GroupManager.disolveGroups(dans       : classe,
                                                           eleveStore : eleveStore)
                                groups = GroupManager.groups(dans       : classe,
                                                             eleveStore : eleveStore)
                            }
                        }
                    } message: {
                        Text("Cette opération est irréversible")
                    }.keyboardShortcut(.defaultAction)
            }
        }
        .task {
            isEditing = false
            updateGroups()
        }
    }

    private func updateGroups() {
        groups = GroupManager.groups(
            dans       : classe,
            eleveStore : eleveStore
        )
        ungrouped.elevesID = GroupManager.unGroupedEleves(
            dans       : classe,
            eleveStore : eleveStore
        )
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPad mini (6th generation)")

            GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPhone 13")
        }
    }
}
