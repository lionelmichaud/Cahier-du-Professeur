//
//  SchoolDetail.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 09/10/2022.
//

import SwiftUI

struct SchoolDetail: View {
    @Binding
    var school: School

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var schoolStore     : SchoolStore
    @EnvironmentObject private var classeStore     : ClasseStore
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State
    private var isAddingNewClasse = false

    @State
    private var noteIsExpanded = false

    @Preference(\.schoolAnnotationEnabled)
    private var schoolAnnotation

    // MARK: - Computed Properties

    private var heures: Double {
        SchoolManager().heures(dans: school, classeStore: classeStore)
    }

    private var name: some View {
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

    private var classeList: some View {
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
                ForEach(classeStore.sortedClasses(dans: school)) { $classe in
                    ClassBrowserRow(classe: classe)
                        .onTapGesture {
                            // Programatic Navigation
                            navigationModel.selectedTab      = .classe
                            navigationModel.selectedClasseId = classe.id
                        }
                        .swipeActions {
                            // supprimer une classe
                            Button(role: .destructive) {
                                withAnimation {
                                    // supprimer la classe et tous ses descendants
                                    // puis retirer la classe de l'établissement auquelle elle appartient
                                    SchoolManager().retirer(classe      : classe,
                                                            deSchool    : &school,
                                                            classeStore : classeStore,
                                                            eleveStore  : eleveStore,
                                                            observStore : observStore,
                                                            colleStore  : colleStore)
                                }
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }

                            // flager une classe
                            Button {
                                withAnimation {
                                    classe.isFlagged.toggle()
                                }
                            } label: {
                                if classe.isFlagged {
                                    Label("Sans drapeau", systemImage: "flag.slash")
                                } else {
                                    Label("Avec drapeau", systemImage: "flag.fill")
                                }
                            }.tint(.orange)
                        }
                }
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

    private var selectedItemExists: Bool {
        guard let selectedSchool = navigationModel.selectedSchoolId else {
            return false
        }
        return schoolStore.contains(selectedSchool)
    }

    var body: some View {
        if selectedItemExists {
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
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onAppear {
                noteIsExpanded = school.annotation.isNotEmpty
            }
            // Modal: ajout d'une nouvelle classe
            .sheet(isPresented: $isAddingNewClasse) {
                NavigationStack {
                    ClassCreator(inSchool: $school)
                }
            }
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

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
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
