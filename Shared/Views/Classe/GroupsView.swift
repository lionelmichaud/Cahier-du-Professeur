//
//  GroupsView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 24/09/2022.
//

import SwiftUI

struct GroupsView: View {
    @Binding
    var classe: Classe

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @EnvironmentObject
    var eleveStore: EleveStore

    @State
    private var isShowingDeleteGroupsDialog = false

    @State
    private var expanded = true

    @State
    private var searchString: String = ""

    @State
    private var groups = [GroupOfEleves]()

    var body: some View {
        Group {
            if groups.count == 0 {
                VStack(alignment: .center, spacing: 10) {
                    Text("Aucun groupe.")
                    Text("Créer des groupes.")
                }

            } else {
                List {
                    ForEach(GroupManager.groups(dans       : classe,
                                                including  : searchString,
                                                eleveStore : eleveStore)) { group in
                        DisclosureGroup(isExpanded: $expanded) {
                            ForEach(group.elevesID, id: \.self) { eleveID in
                                if let eleve = eleveStore.item(withID: eleveID) {
                                    EleveLabel(eleve: eleve)
                                }
                            }
                        } label: {
                            Text("Groupe \(group.number.formatted())")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .searchable(text      : $searchString,
                            placement : .navigationBarDrawer(displayMode : .automatic),
                            prompt    : "Nom ou Prénom de l'élève")
                .disableAutocorrection(true)
            }
        }
        #if os(iOS)
        .navigationTitle("Groupes " + classe.displayString + " (\(classe.nbOfEleves) élèves)")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    /// Générer les groupes
                    Menu {
                        Menu("Automatiquement") {
                            Menu("Par ordre alphabétique") {
                                Button("2 élèves") {
                                    withAnimation {
                                        GroupManager.formOrderedGroups(nbEleveParGroupe : 2,
                                                                       dans             : classe,
                                                                       eleveStore       : eleveStore)
                                    }
                                }
                                Button("3 élèves") {
                                    withAnimation {
                                        GroupManager.formOrderedGroups(nbEleveParGroupe: 3,
                                                                       dans             : classe,
                                                                       eleveStore       : eleveStore)
                                    }
                                }
                                Button("4 élèves") {
                                    withAnimation {
                                        GroupManager.formOrderedGroups(nbEleveParGroupe: 4,
                                                                       dans             : classe,
                                                                       eleveStore       : eleveStore)
                                    }
                                }
                                Button("5 élèves") {
                                    withAnimation {
                                        GroupManager.formOrderedGroups(nbEleveParGroupe: 5,
                                                                       dans             : classe,
                                                                       eleveStore       : eleveStore)
                                    }
                                }
                            }

                            Menu("Aléatoirement") {
                                Button("2 élèves") {
                                    withAnimation {
                                        GroupManager.formRandomGroups(nbEleveParGroupe: 2,
                                                                      dans             : classe,
                                                                      eleveStore       : eleveStore)
                                    }
                                }
                                Button("3 élèves") {
                                    withAnimation {
                                        GroupManager.formRandomGroups(nbEleveParGroupe: 3,
                                                                      dans             : classe,
                                                                      eleveStore       : eleveStore)
                                    }
                                }
                                Button("4 élèves") {
                                    withAnimation {
                                        GroupManager.formRandomGroups(nbEleveParGroupe: 4,
                                                                      dans             : classe,
                                                                      eleveStore       : eleveStore)
                                    }
                                }
                                Button("5 élèves") {
                                    withAnimation {
                                        GroupManager.formRandomGroups(nbEleveParGroupe: 5,
                                                                      dans             : classe,
                                                                      eleveStore       : eleveStore)
                                    }
                                }
                            }
                        }

                        Button("Manuellement", action: {})

                    } label: {
                        Label("Générer les groupes", systemImage: "person.line.dotted.person.fill")
                    }

                    /// Supprimer les groupes
                    Button {
                        isShowingDeleteGroupsDialog.toggle()
                    } label: {
                        Label("Suprimer les groupes", systemImage: "trash")
                    }

                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .padding(4)
                }
                /// Confirmation de suppresssion de tous les groupes
                .confirmationDialog(
                    "Supression de tous les groupes",
                    isPresented     : $isShowingDeleteGroupsDialog,
                    titleVisibility : .visible) {
                        Button("Supprimer", role: .destructive) {
                            withAnimation {
                                GroupManager.disolveGroups(dans       : classe,
                                                           eleveStore : eleveStore)
                            }
                        }
                    } message: {
                        Text("Cette opération est irréversible")
                    }.keyboardShortcut(.defaultAction)
            }
        }
        .task {
            groups = GroupManager.groups(dans       : classe,
                                         eleveStore : eleveStore)
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
    }
}
