//
//  ClassDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import AppFoundation
import HelpersView

enum ClasseSubviewEnum {
    case trombinoscope
    case groups
}

struct ClasseSubview: Hashable {
    var classe      : Binding<Classe>
    var subviewType : ClasseSubviewEnum

    static func == (lhs: ClasseSubview, rhs: ClasseSubview) -> Bool {
        lhs.subviewType == rhs.subviewType &&
        lhs.classe.wrappedValue.id == rhs.classe.wrappedValue.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(subviewType)
        hasher.combine(classe.wrappedValue)
    }
}

struct ExamSubview: Hashable {
    var classe : Binding<Classe>
    var examId : UUID

    static func == (lhs: ExamSubview, rhs: ExamSubview) -> Bool {
        lhs.examId == rhs.examId &&
        lhs.classe.wrappedValue.id == rhs.classe.wrappedValue.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(examId)
        hasher.combine(classe.wrappedValue.id)
    }
}

struct ClasseDetail: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State
    private var alertItem : AlertItem?
    @State
    private var isShowingImportListeDialog = false
    @State
    private var importCsvFile = false

    @Preference(\.interoperability)
    var interoperability

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

    private var elevesList: some View {
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
            Text("Liste")
//                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var trombinoscope: some View {
        NavigationLink(value: ClasseSubview(classe      : $classe,
                                            subviewType : .trombinoscope)) {
            Text("Trombinoscope")
//                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var groups: some View {
        NavigationLink(value: ClasseSubview(classe      : $classe,
                                            subviewType : .groups)) {
            Text("Groupes")
//                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var examsList: some View {
        Group {
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
                NavigationLink(value: ExamSubview(classe: $classe,
                                                  examId: exam.id)) {
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
        }
    }

    var body: some View {
        VStack {
            /// nom
            ClasseNameGroupBox(classe: $classe)

            List {
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

                Section {
                    /// édition de la liste des élèves
                    elevesList

                    /// trombinoscope
                    if eleveTrombineEnabled {
                        trombinoscope
                    }

                    /// gestion des groupes
                    groups
                } header: {
                    Text("Elèves (\(classe.nbOfEleves))")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                }

                /// édition de la liste des examens
                Section {
                    examsList
                } header: {
                    Text("Evaluations (\(classe.nbOfExams))")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                /// Importation des données
                /// Importer une liste d'élèves d'une classe depuis un fichier CSV au format PRONOTE
                Button {
                    isShowingImportListeDialog.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .imageScale(.large)
                }
                /// Confirmation de l'importation d'une liste d'élèves d'une classe
                .confirmationDialog("Importer une liste d'élèves",
                                    isPresented     : $isShowingImportListeDialog,
                                    titleVisibility : .visible) {
                    Button("Importer et ajouter") {
                        withAnimation {
                            importCsvFile = true
                        }
                    }
                    Button("Importer et remplacer", role: .destructive) {
                        withAnimation {
                            ClasseManager().retirerTousLesEleves(deClasse    : &classe,
                                                                 eleveStore  : eleveStore,
                                                                 observStore : observStore,
                                                                 colleStore  : colleStore)
                        }
                        importCsvFile = true
                    }
                } message: {
                    Text("La liste des élèves importée doit être au format CSV de \(interoperability == .proNote ? "PRONOTE" : "EcoleDirecte").") +
                    Text("Cette action ne peut pas être annulée.")
                }
            }
        }
        .alert(item: $alertItem, content: newAlert)
        /// Importer un fichier CSV au format PRONOTE ou EcoleDirecte
        .fileImporter(isPresented             : $importCsvFile,
                      allowedContentTypes     : [.commaSeparatedText],
                      allowsMultipleSelection : false) { result in
            importCsvFiles(result: result)
        }
        #if os(iOS)
        .navigationTitle("Classe")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            appreciationIsExpanded = classe.appreciation.isNotEmpty
            noteIsExpanded         = classe.annotation.isNotEmpty
        }
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationStack {
                EleveCreator(classe: $classe)
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isAddingNewExam) {
            NavigationStack {
                ExamCreator(elevesId: classe.elevesID) { newExam in
                    /// Ajouter une nouvelle évaluation
                    withAnimation {
                        classe.exams.insert(newExam, at: 0)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Methods

    private func importCsvFiles(result: Result<[URL], Error>) {
        switch result {
            case .failure(let error):
                self.alertItem = AlertItem(title         : Text("Échec"),
                                           message       : Text("L'importation du fichier a échouée"),
                                           dismissButton : .default(Text("OK")))
                print("Error selecting file: \(error.localizedDescription)")

            case .success(let filesUrl):
                filesUrl.forEach { fileUrl in
                    guard fileUrl.startAccessingSecurityScopedResource() else { return }

                    if let data = try? Data(contentsOf: fileUrl) {
                        do {
                            var eleves = [Eleve]()

                            switch interoperability {
                                case .ecoleDirecte:
                                    eleves = try CsvImporter().importElevesFromEcoleDirecte(from: data)

                                case .proNote:
                                    eleves = try CsvImporter().importElevesFromPRONOTE(from: data)
                            }

                            for idx in eleves.startIndex...eleves.endIndex-1 {
                                withAnimation {
                                    ClasseManager()
                                        .ajouter(eleve      : &eleves[idx],
                                                 aClasse    : &classe,
                                                 eleveStore : eleveStore)
                                }
                            }
                        } catch let error {
                            self.alertItem = AlertItem(title         : Text("Échec"),
                                                       message       : Text("L'importation du fichier a échouée"),
                                                       dismissButton : .default(Text("OK")))
                            print("Error reading file \(error.localizedDescription)")
                        }
                    }

                    fileUrl.stopAccessingSecurityScopedResource()
                }
        }
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ClasseDetail(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ClasseDetail(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
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
