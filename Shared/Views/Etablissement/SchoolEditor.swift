//
//  SchoolEditor.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolEditor: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var schoolStore     : SchoolStore

    // MARK: - Computed Properties

    private var selectedItemExists: Bool {
        guard let selectedSchool = navigationModel.selectedSchoolId else {
            return false
        }
        return schoolStore.contains(selectedSchool)
    }

    var body: some View {
        if selectedItemExists {
            SchoolDetail(school: schoolStore.itemBinding(withID: navigationModel.selectedSchoolId!)!)
        } else {
            VStack(alignment: .center) {
                Text("Aucun établissement sélectionné.")
                Text("Sélectionner un établissement.")
            }
            .foregroundStyle(.secondary)
            .font(.title)
        }
    }
}

//struct SchoolEditor: View {
//    init(navigationModel : NavigationModel,
//         schoolStore     : SchoolStore) {
//        guard let selectedSchool = navigationModel.selectedSchoolId else {
//            return
//        }
//        self.school = schoolStore.itemBinding(withID: selectedSchool)
//    }
//
//    private var school: Binding<School>?
//
//    @EnvironmentObject private var navigationModel : NavigationModel
//    @EnvironmentObject private var schoolStore     : SchoolStore
//    @EnvironmentObject private var classeStore     : ClasseStore
//
//    @State
//    private var isAddingNewClasse = false
//
//    @State
//    private var noteIsExpanded = false
//
//    @Preference(\.schoolAnnotationEnabled)
//    private var schoolAnnotation
//
//    // MARK: - Computed Properties
//
//    private var heures: Double {
//        SchoolManager().heures(dans: school!.wrappedValue, classeStore: classeStore)
//    }
//
//    private var name: some View {
//        HStack {
//            Image(systemName: school!.wrappedValue.niveau == .lycee ? "building.2" : "building")
//                .imageScale(.large)
//                .foregroundColor(school!.wrappedValue.niveau == .lycee ? .mint : .orange)
//            TextField("Nouvel établissement", text: school!.nom)
//                .font(.title2)
//                .textFieldStyle(.roundedBorder)
//        }
//        .listRowSeparator(.hidden)
//    }
//
//    private var classeList: some View {
//        Section {
//            DisclosureGroup {
//                // ajouter une classe
//                Button {
//                    isAddingNewClasse = true
//                } label: {
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                        Text("Ajouter une classe")
//                    }
//                }
//                .buttonStyle(.borderless)
//
//                // édition de la liste des classes
//                ClasseSidebarSchoolSubview(school: school!)
//            } label: {
//                // titre
//                HStack {
//                    Text(school!.wrappedValue.classesLabel)
//                        .fontWeight(.bold)
//                    Spacer()
//                    Text("\(heures.formatted(.number.precision(.fractionLength(1)))) h")
//                        .fontWeight(.bold)
//                }
//                .font(.title3)
//            }
//        }
//    }
//
//    private var ressourceList: some View {
//        Section {
//            DisclosureGroup {
//                // ajouter une évaluation
//                Button {
//                    withAnimation {
//                        school!.wrappedValue.ressources.insert(Ressource(), at: 0)
//                    }
//                } label: {
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                        Text("Ajouter une ressource")
//                    }
//                }
//                .buttonStyle(.borderless)
//
//                // édition de la liste des examen
//                ForEach(school!.ressources) { $res in
//                    RessourceEditor(ressource: $res)
//                }
//                .onDelete { indexSet in
//                    school!.wrappedValue.ressources.remove(atOffsets: indexSet)
//                }
//                .onMove { fromOffsets, toOffset in
//                    school!.wrappedValue.ressources.move(fromOffsets: fromOffsets, toOffset: toOffset)
//                }
//
//            } label: {
//                Text(school!.wrappedValue.ressourcesLabel)
//                    .font(.title3)
//                    .fontWeight(.bold)
//            }
//        }
//    }
//
//    private var selectedItemExists: Bool {
//        guard let selectedSchool = navigationModel.selectedSchoolId, school != nil else {
//            return false
//        }
//        return schoolStore.contains(selectedSchool)
//    }
//
//    var body: some View {
//        if selectedItemExists {
//            List {
//                // nom de l'établissement
//                name
//
//                // note sur la classe
//                if schoolAnnotation {
//                    AnnotationView(isExpanded: $noteIsExpanded,
//                                   annotation: school!.annotation)
//                }
//                // édition de la liste des classes
//                classeList
//
//                // édition de la liste des ressources
//                ressourceList
//            }
//#if os(iOS)
//            .navigationTitle("Etablissement")
//            .navigationBarTitleDisplayMode(.inline)
//#endif
//            .onAppear {
//                noteIsExpanded = school!.wrappedValue.annotation.isNotEmpty
//            }
//            // Modal: ajout d'une nouvelle classe
//            .sheet(isPresented: $isAddingNewClasse) {
//                NavigationStack {
//                    ClassCreator(inSchool: school!)
//                }
//            }
//        } else {
//            VStack(alignment: .center) {
//                Text("Aucun établissement sélectionné.")
//                Text("Sélectionner un établissement.")
//            }
//            .foregroundStyle(.secondary)
//            .font(.title)
//        }
//    }
//}

struct SchoolEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                SchoolEditor()
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                SchoolEditor()
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
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
