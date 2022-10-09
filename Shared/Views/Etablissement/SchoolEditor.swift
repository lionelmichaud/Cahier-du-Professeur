//
//  SchoolEditor.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolEditor: View {
    @Binding
    var school    : School

    @State
    var isModified: Bool = false

    @EnvironmentObject var schoolStore : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore

    @State
    private var isAddingNewClasse = false

    @State
    private var noteIsExpanded = false

    @State
    private var alertItem : AlertItem?

    @Preference(\.schoolAnnotationEnabled)
    var schoolAnnotation
    // si l'item va être détruit
    @State private var isDeleted = false

    private var isItemDeleted: Bool {
        !schoolStore.isPresent(school)
    }

    var heures: Double {
        SchoolManager().heures(dans: school, classeStore: classeStore)
    }

    var name: some View {
        HStack {
            Image(systemName: school.niveau == .lycee ? "building.2" : "building")
                .imageScale(.large)
                .foregroundColor(school.niveau == .lycee ? .mint : .orange)
            TextField("Nouvel établissement", text: $school.nom)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
        }
        .listRowSeparator(.hidden)
    }

    var classeList: some View {
        Section {
            DisclosureGroup {
                // ajouter une classe
                Button {
                    isAddingNewClasse = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une classe")
                    }
                }
                .buttonStyle(.borderless)

                // édition de la liste des classes
                ClasseBrowserSchoolSubview(school: $school)
            } label: {
                // titre
                HStack {
                    Text(school.classesLabel)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(heures.formatted(.number.precision(.fractionLength(1)))) h")
                        .fontWeight(.bold)
                }
                .font(.title3)
            }
        }
    }

    private var ressourceList: some View {
        Section {
            DisclosureGroup {
                // ajouter une évaluation
                Button {
                    withAnimation {
                        school.ressources.insert(Ressource(), at: 0)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une ressource")
                    }
                }
                .buttonStyle(.borderless)

                // édition de la liste des examen
                ForEach($school.ressources) { $res in
                    RessourceEditor(ressource: $res)
                }
                .onDelete { indexSet in
                    school.ressources.remove(atOffsets: indexSet)
                }
                .onMove { fromOffsets, toOffset in
                    school.ressources.move(fromOffsets: fromOffsets, toOffset: toOffset)
                }

            } label: {
                Text(school.ressourcesLabel)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    var body: some View {
        List {
            // nom de l'établissement
            name

            // note sur la classe
            if schoolAnnotation {
                AnnotationView(isExpanded: $noteIsExpanded,
                               annotation: $school.annotation)
            }
            // édition de la liste des classes
            classeList

            // édition de la liste des ressources
            ressourceList
        }
        #if os(iOS)
        .navigationTitle("Etablissement")
        #endif
        .onAppear {
            noteIsExpanded = school.annotation.isNotEmpty
        }
        .disabled(isItemDeleted)
        // Modal: ajout d'une nouvelle classe
        .sheet(isPresented: $isAddingNewClasse) {
            NavigationStack {
                ClassCreator { classe in
                    /// Ajouter une nouvelle classe
                    if classeStore.exists(classe: classe, in: school.id) {
                        self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                   message       : Text("Cette classe existe déjà dans cet établissement"),
                                                   dismissButton : .default(Text("OK")))
                    } else if !isCompatible(classe, school) {
                        self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                   message       : Text("Cette niveau de classe n'existe pas dans ce type d'établissement"),
                                                   dismissButton : .default(Text("OK")))
                    } else {
                        var _classe = classe
                        withAnimation {
                            SchoolManager()
                                .ajouter(classe      : &_classe,
                                         aSchool     : &school,
                                         classeStore : classeStore)
                        }
                    }
                }
            }
            .alert(item: $alertItem, content: newAlert)
        }
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Etablissement supprimé. Sélectionner un établissement.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    func isCompatible(_ classe: Classe, _ school: School) -> Bool {
        switch classe.niveau {
            case .n6ieme, .n5ieme, .n4ieme, .n3ieme:
                return school.niveau == .college

            case .n2nd, .n1ere, .n0terminale:
                return school.niveau == .lycee
        }
    }
}

struct SchoolEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return SchoolEditor(school : .constant(TestEnvir.schoolStore.items.first!))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
    }
}
