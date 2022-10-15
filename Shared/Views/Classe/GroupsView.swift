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
    private var presentation = "Liste"

    private var menu: some View {
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
            if presentation == "Liste" {
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
                            if presentation == "Liste" {
                                GroupListView(group    : group,
                                              classe   : classe,
                                              isEditing: isEditing)
                            } else {
                                GroupPicturesView(group: group)
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
        .navigationTitle("Groupes " + classe.displayString + " (\(classe.nbOfEleves))")
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Picker("Présentation", selection: $presentation) {
                    Image(systemName: "list.bullet").tag("Liste")
                    Image(systemName: "person.crop.square.fill").tag("Pictures")
                }
                .pickerStyle(.segmented)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                menu
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
            updateGroups()
        }
    }

    private func updateGroups() {
        groups = GroupManager.groups(dans       : classe,
                                     eleveStore : eleveStore)
    }
}

struct GroupListView : View {
    let group    : GroupOfEleves
    var classe   : Classe
    let isEditing: Bool

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

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
                            Label((eleveStore.item(withID: eleveID)?.displayName(nameDisplayOrder))!, systemImage: "person.fill")
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
                            // Programatic Navigation
                            navigationModel.selectedTab     = .eleve
                            navigationModel.selectedEleveId = eleve.id
                        }
                        .swipeActions {
                            if isEditing {
                                // supprimer une évaluation
                                Button(role: .destructive) {
                                    withAnimation {
                                        eleve.wrappedValue.group = nil
                                    }
                                } label: {
                                    Label("Retirer", systemImage: "person.fill.badge.minus")
                                }
                            }
                        }
                }
            }
        }
    }
}

struct GroupPicturesView : View {
    let group: GroupOfEleves

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    let smallColumns = [GridItem(.adaptive(minimum: 120, maximum: 200))]
    let font       : Font        = .title3
    let fontWeight : Font.Weight = .semibold

    var body: some View {
        LazyVGrid(columns: smallColumns,
                  spacing: 4) {
            ForEach(group.elevesID, id: \.self) { eleveID in
                if let eleve = eleveStore.item(withID: eleveID) {
                    VStack {
                        if let trombine = Trombinoscope.eleveTrombineUrl(eleve: eleve) {
                            LoadableImage(imageUrl: trombine)
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
                        .onTapGesture {
                            // Programatic Navigation
                            navigationModel.selectedTab     = .eleve
                            navigationModel.selectedEleveId = eleve.id
                        }
                }
            }
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return GroupsView(classe: .constant(TestEnvir.classeStore.items.first!))
            .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
    }
}
