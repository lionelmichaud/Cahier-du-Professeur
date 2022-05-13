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
    var classe    : Classe
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewEleve = false
    @State
    private var newEleve = Eleve.exemple
    @State
    private var isAddingNewExam = false
    @State
    private var newExam = Exam()
    @State
    private var appreciationIsExpanded = false
    @State
    private var noteIsExpanded = false
    @FocusState
    private var isHoursFocused: Bool

    var name: some View {
        HStack {
            Image(systemName: "person.3.fill")
                .sfSymbolStyling()
                .foregroundColor(classe.niveau.color)

            if isNew {
                // niveau de cette classe
                CasePicker(pickedCase: $classe.niveau, label: "Niveau")
                    .pickerStyle(.menu)
                // numéro de cette classe
                Picker("Numéro", selection: $classe.numero) {
                    ForEach(1...8, id: \.self) { num in
                        Text(String(num))
                    }
                }
                .pickerStyle(.menu)

            } else {
                Text(classe.displayString)
                    .font(.title2)
                    .fontWeight(.semibold)
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
                .onChange(of: classe.isFlagged) {newValue in
                    isModified = true
                }
            }

            // nombre d'heures d'enseignement pour cette classe
            if isNew || isEditing {
                Toggle(isOn: $classe.segpa) {
                    Text("SEGPA")
                }
                .toggleStyle(.button)

                Spacer()

                AmountEditView(label: "Heures",
                               amount: $classe.heures,
                               validity: .poz,
                               currency: false)
                .focused($isHoursFocused)
                .frame(maxWidth: 150)
            } else {
                Spacer()

                Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) h")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
        .listRowSeparator(.hidden)
    }

    var appreciation: some View {
        DisclosureGroup(isExpanded: $appreciationIsExpanded) {
            TextEditor(text: $classe.appreciation)
                .multilineTextAlignment(.leading)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                .frame(minHeight: 80)
        } label: {
            Text("Appréciation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .onChange(of: classe.appreciation) {newValue in
            isModified = true
        }
    }

    var annotation: some View {
        DisclosureGroup(isExpanded: $noteIsExpanded) {
            TextEditor(text: $classe.note)
                .multilineTextAlignment(.leading)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                .frame(minHeight: 80)
        } label: {
            Text("Annotation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .onChange(of: classe.note) {newValue in
            isModified = true
        }
    }

    var eleveList: some View {
        Section {
            // ajouter un élève
            Button {
                isModified = true
                newEleve = Eleve(sexe   : .male,
                                 nom    : "",
                                 prenom : "")
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
                NavigationLink {
                    EleveEditor(classe : $classe,
                                eleve  : $eleve,
                                isNew  : false)
                } label: {
                    ClasseEleveRow(eleve: eleve)
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

        } header: {
            Text(classe.elevesLabel)
        }
        .headerProminence(.increased)
    }

    var examList: some View {
        Section {
            // ajouter un élève
            Button {
                isModified      = true
                newExam         = Exam()
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
                               exam   : $exam,
                               isNew  : false)
                } label: {
                    ClasseExamRow(exam: exam)
                }
            }

        } header: {
            Text(classe.examsLabel)
        }
        .headerProminence(.increased)
    }

    var body: some View {
        List {
            // nom
            name

            // élèves dans la classe
            if !isNew {
                // appréciation sur la classe
                appreciation
                // note sur la classe
                annotation
                // édition de la liste des élèves
                eleveList
                // édition de la liste des examens
                examList
            }
        }
        #if os(iOS)
        .navigationTitle("Classe")
        #endif
        .onAppear {
            isHoursFocused = isNew
        }
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationView {
                EleveEditor(classe : $classe,
                            eleve  : $newEleve,
                            isNew  : true)
            }
        }
        .sheet(isPresented: $isAddingNewExam) {
            NavigationView {
                ExamEditor(classe : $classe,
                           exam   : $newExam,
                           isNew  : true)
            }
        }
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseDetail(classe   : .constant(TestEnvir.classeStore.items.first!),
                         isEditing : false,
                         isNew     : true,
                         isModified: .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDisplayName("NewClasse")

            ClasseDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                         isEditing : false,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDevice("iPhone Xs")
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDisplayName("DisplayClasse")
        }
    }
}
