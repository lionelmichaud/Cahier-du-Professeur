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
    var eleveStore: EleveStore

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
                            Menu("Automatiquement") {
                                Menu("Par ordre alphabétique") {
                                    Button("2 élèves") {
                                        withAnimation() {
                                            formOrderedGroups(nbEleveParGroupe: 2)
                                        }
                                    }
                                    Button("3 élèves") {
                                        withAnimation() {
                                            formOrderedGroups(nbEleveParGroupe: 3)
                                        }
                                    }
                                    Button("4 élèves") {
                                        withAnimation() {
                                            formOrderedGroups(nbEleveParGroupe: 4)
                                        }
                                    }
                                    Button("5 élèves") {
                                        withAnimation() {
                                            formOrderedGroups(nbEleveParGroupe: 5)
                                        }
                                    }
                                }

                                Menu("Aléatoirement") {
                                    Button("2 élèves") {
                                        withAnimation() {
                                            formRandomGroups(nbEleveParGroupe: 2)
                                        }
                                    }
                                    Button("3 élèves") {
                                        withAnimation() {
                                            formRandomGroups(nbEleveParGroupe: 3)
                                        }
                                    }
                                    Button("4 élèves") {
                                        withAnimation() {
                                            formRandomGroups(nbEleveParGroupe: 4)
                                        }
                                    }
                                    Button("5 élèves") {
                                        withAnimation() {
                                            formRandomGroups(nbEleveParGroupe: 5)
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
                                withAnimation() {
                                    deleteGroups()
                                }
                            }
                        } message: {
                            Text("Cette opération est irréversible")
                        }.keyboardShortcut(.defaultAction)
                }
            }
    }

    private func formOrderedGroups(nbEleveParGroupe: Int) {
        func formRegularGroups(_ nb: Int) {
            for idx in eleves.indices {
                let (q, _) = idx.quotientAndRemainder(dividingBy: nbEleveParGroupe)
                eleves[idx].wrappedValue.group = q + 1
            }
        }

        let eleves: Binding<[Eleve]> = eleveStore.filteredEleves(dans: classe)
        let nbEleves = eleves.count
        let (nbGroupes, reste) = nbEleves.quotientAndRemainder(dividingBy: nbEleveParGroupe)
        let distributeRemainder = reste > 0 && (reste.double() < nbEleveParGroupe.double() / 2.0)

        if reste == 0 {
            // nombre entier de groupes complets
            formRegularGroups(nbGroupes)

        } else if distributeRemainder {
            // les élèves formant un groupe incomplet sont redistribués sur les derniers groupes complets
            let nbOfRegularGroups = nbGroupes - reste
            let firstRemainEleveIndex = nbOfRegularGroups * nbEleveParGroupe
            formRegularGroups(nbGroupes)
            for group in nbOfRegularGroups + 1 ... nbOfRegularGroups + reste {
                for i in 0 ... nbEleveParGroupe {
                    eleves[firstRemainEleveIndex + i * (group - nbOfRegularGroups)].wrappedValue.group = group
                }
            }

        } else {
            // le dernier groupe est laissé incomplet
            formRegularGroups(nbGroupes)
            for idx in (eleves.endIndex-reste) ... eleves.endIndex-1 {
                eleves[idx].wrappedValue.group = nbGroupes + 1
            }
        }
        eleves.forEach { eleve in
            print(eleve.wrappedValue.displayName(.nomPrenom) + String(describing: eleve.group))
        }

    }

    private func formRandomGroups(nbEleveParGroupe: Int) {

    }

    private func deleteGroups() {
        let eleves: Binding<[Eleve]> = eleveStore.filteredEleves(dans: classe)
        for idx in eleves.indices {
            eleves[idx].wrappedValue.group = nil
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
    }
}
