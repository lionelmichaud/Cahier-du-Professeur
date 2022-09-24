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

    @EnvironmentObject
    var eleveStore  : EleveStore

    @State
    private var isShowingDeleteGroupsDialog = false

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            #if os(iOS)
            .navigationTitle("Groupes " + classe.displayString + " (\(classe.nbOfEleves) élèves)")
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        /// Générer les groupes
                        Menu {
                            Button("Manuellement", action: {})
                            Menu("Automatiquement") {
                                Menu("Par ordre alphabétique") {
                                    Button("2 élèves") {
                                        withAnimation() {
                                            generateOrderedGroups(nbEleveParGroupe: 2)
                                        }
                                    }
                                    Button("3 élèves") {
                                        withAnimation() {
                                            generateOrderedGroups(nbEleveParGroupe: 3)
                                        }
                                    }
                                    Button("4 élèves") {
                                        withAnimation() {
                                            generateOrderedGroups(nbEleveParGroupe: 4)
                                        }
                                    }
                                    Button("5 élèves") {
                                        withAnimation() {
                                            generateOrderedGroups(nbEleveParGroupe: 5)
                                        }
                                    }
                                }

                                Menu("Aléatoirement") {
                                    Button("2 élèves") {
                                        withAnimation() {
                                            generateRandomGroups(nbEleveParGroupe: 2)
                                        }
                                    }
                                    Button("3 élèves") {
                                        withAnimation() {
                                            generateRandomGroups(nbEleveParGroupe: 3)
                                        }
                                    }
                                    Button("4 élèves") {
                                        withAnimation() {
                                            generateRandomGroups(nbEleveParGroupe: 4)
                                        }
                                    }
                                    Button("5 élèves") {
                                        withAnimation() {
                                            generateRandomGroups(nbEleveParGroupe: 5)
                                        }
                                    }
                                }
                            }
                        } label: {
                            Label("Générer les groupes", systemImage: "person.line.dotted.person")
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
                                withAnimation() {
                                }
                            }
                        } message: {
                            Text("Cette opération est irréversible")
                        }.keyboardShortcut(.defaultAction)
                }
            }
    }

    private func generateOrderedGroups(nbEleveParGroupe: Int) {

    }

    private func generateRandomGroups(nbEleveParGroupe: Int) {

    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
    }
}
