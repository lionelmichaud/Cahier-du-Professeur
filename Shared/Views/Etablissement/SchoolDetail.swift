//
//  SchoolDetail.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolDetail: View {
    @Binding
    var school    : School
    @State
    var isModified: Bool = false

    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewClasse = false
    @State
    private var isAddingNewRessource = false
    @State
    private var newClasse = Classe.exemple
    @State
    private var noteIsExpanded = false
    @Preference(\.schoolAnnotationEnabled)
    var schoolAnnotation
    @Environment(\.horizontalSizeClass)
    var hClass

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
                    newClasse = Classe(niveau: .n6ieme, numero: 1)
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
                    NavigationLink {
                        ClasseEditor(school : $school,
                                     classe : $classe,
                                     isNew  : false)
                    } label: {
                        SchoolClasseRow(classe: classe)
                    }
                    .swipeActions {
                        // supprimer un élève
                        Button(role: .destructive) {
                            withAnimation {
                                // supprimer l'élève et tous ses descendants
                                // puis retirer l'élève de la classe auquelle il appartient
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

                        // flager un élève
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
                    isAddingNewRessource = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une ressource")
                    }
                }
                .buttonStyle(.borderless)

                // édition de la liste des examen
                ForEach($school.ressources) { $ressource in
                    NavigationLink {
                        RessourceEditor(ressource: $ressource)
                    } label: {
                        SchoolRessourceRow(ressource: ressource)
                    }
                    .swipeActions {
                        // supprimer une évaluation
                        Button(role: .destructive) {
                            withAnimation {
                                school.ressources.removeAll {
                                    $0.id == ressource.id
                                }
                            }
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
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

            // type d'établissement
                CasePicker(pickedCase: $school.niveau,
                           label: "Type d'établissement")
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)

                // note sur la classe
                if schoolAnnotation {
                    AnnotationView(isExpanded: $noteIsExpanded,
                                   isModified: $isModified,
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
        // Modal: ajout d'une nouvelle classe
        .sheet(isPresented: $isAddingNewClasse) {
            NavigationView {
                ClasseEditor(school : $school,
                             classe : $newClasse,
                             isNew  : true)
            }
        }
        // Modal: ajout d'une nouvelle ressource
        .sheet(isPresented: $isAddingNewRessource) {
            NavigationView {
                Text("Créaion")
//                ClasseEditor(school : $school,
//                             classe : $newClasse,
//                             isNew  : true)
            }
        }
    }
}

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
            .previewDisplayName("Display")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
            .previewDisplayName("Edit")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewInterfaceOrientation(.portraitUpsideDown)
            SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
            .previewDisplayName("New")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
        }
    }
}
