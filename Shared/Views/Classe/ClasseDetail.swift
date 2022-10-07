//
//  ClassDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import AppFoundation
import HelpersView

struct ClasseDetail: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore
    @State
    var isModified: Bool = false
    @State
    private var isAddingNewEleve = false
    @State
    private var isAddingNewExam = false
    @State
    private var appreciationIsExpanded = false
    @State
    private var noteIsExpanded = false
    @Preference(\.classeAppreciationEnabled)
    var classeAppreciationEnabled
    @Preference(\.classeAnnotationEnabled)
    var classeAnnotationEnabled
    @Preference(\.eleveTrombineEnabled)
    private var eleveTrombineEnabled

    private var name: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)
            Text(classe.displayString)
                .font(.title2)
                .fontWeight(.semibold)

            // Flag de la classe
            Button {
                classe.isFlagged.toggle()
            } label: {
                if classe.isFlagged {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "flag")
                        .foregroundColor(.orange)
                }
            }

            // SEGPA ou pas
            Toggle(isOn: $classe.segpa) {
                Text("SEGPA")
                    .font(.caption)
            }
            .toggleStyle(.button)
            .controlSize(.small)

            Spacer()

            // Nombre d'heures d'enseignement pour cette classe
            AmountEditView(label: "Heures",
                           amount: $classe.heures,
                           validity: .poz,
                           currency: false)
            .frame(maxWidth: 150)
        }
        .listRowSeparator(.hidden)
    }

    private var elevesList: some View {
        Section {
            DisclosureGroup {
                // ajouter un élève
                Button {
                    isAddingNewEleve = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter un élève")
                    }
                }
                .buttonStyle(.borderless)

                // édition de la liste des élèves
                ForEach(eleveStore.filteredEleves(dans: classe)) { $eleve in
                    ClasseEleveRow(eleve: eleve)
                        .onTapGesture {
                            // Programatic Navigation
                            navigationModel.selectedTab     = .eleve
                            navigationModel.selectedEleveId = eleve.id
                        }
                        .swipeActions {
                            // supprimer un élève
                            Button(role: .destructive) {
                                withAnimation {
                                    // supprimer l'élève et tous ses descendants
                                    // puis retirer l'élève de la classe auquelle il appartient
                                    ClasseManager().retirer(eleve       : eleve,
                                                            deClasse    : &classe,
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
                                    eleve.isFlagged.toggle()
                                }
                            } label: {
                                if eleve.isFlagged {
                                    Label("Sans drapeau", systemImage: "flag.slash")
                                } else {
                                    Label("Avec drapeau", systemImage: "flag.fill")
                                }
                            }.tint(.orange)
                        }
                }

            } label: {
                Text(classe.elevesListLabel)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    private var trombinoscope: some View {
        Section {
            NavigationLink {
                TrombinoscopeView(classe : $classe)
            } label: {
                Text("Trombinoscope")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    private var groups: some View {
        Section {
            NavigationLink {
                GroupsView(classe : $classe)
            } label: {
                Text("Groupes")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    private var examsList: some View {
        Section {
            DisclosureGroup {
                // ajouter une évaluation
                Button {
                    isAddingNewExam = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une évaluation")
                    }
                }
                .buttonStyle(.borderless)

                // édition de la liste des examen
                ForEach($classe.exams) { $exam in
                    NavigationLink {
                        ExamEditor(classe : $classe,
                                   exam   : $exam)
                    } label: {
                        ClasseExamRow(exam: exam)
                    }
                    .swipeActions {
                        // supprimer une évaluation
                        Button(role: .destructive) {
                            withAnimation {
                                classe.exams.removeAll {
                                    $0.id == exam.id
                                }
                            }
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }

            } label: {
                Text(classe.examsListLabel)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    var body: some View {
        List {
            /// nom
            name

            /// appréciation sur la classe
            if classeAppreciationEnabled {
                AppreciationView(isExpanded  : $appreciationIsExpanded,
                                 appreciation: $classe.appreciation)
            }
            /// annotation sur la classe
            if classeAnnotationEnabled {
                AnnotationView(isExpanded: $noteIsExpanded,
                               annotation: $classe.annotation)
            }

            /// édition de la liste des élèves
            elevesList

            /// trombinoscope
            if eleveTrombineEnabled {
                trombinoscope
            }

            /// gestion des groupes
            groups

            /// édition de la liste des examens
            examsList
        }
        #if os(iOS)
        .navigationTitle("Classe")
        #endif
        .onAppear {
            appreciationIsExpanded = classe.appreciation.isNotEmpty
            noteIsExpanded         = classe.annotation.isNotEmpty
        }
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationView {
                EleveCreator(classe: $classe)
            }
        }
        .sheet(isPresented: $isAddingNewExam) {
            NavigationView {
                ExamCreator(elevesId: classe.elevesID) { newExam in
                    /// Ajouter une nouvelle évaluation
                    withAnimation {
                        classe.exams.insert(newExam, at: 0)
                    }
                }
            }
        }
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseDetail(classe: .constant(TestEnvir.classeStore.items.first!))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDisplayName("NewClasse")
        }
    }
}
