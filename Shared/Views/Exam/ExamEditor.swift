//
//  ExamEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 13/05/2022.
//

import SwiftUI

struct ExamEditor: View {
    @Binding
    var classe : Classe

    @Binding
    var exam   : Exam

    @EnvironmentObject private var eleveStore: EleveStore
    @State
    private var searchString: String = ""
    @Environment(\.isSearching) var isSearching

    private var name: some View {
        HStack {
            Image(systemName: "doc.plaintext")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)

            // sujet
            TextField("Sujet de l'évaluation", text: $exam.sujet)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
        }
        .listRowSeparator(.hidden)
    }

    private var markList: some View {
        Section {
            ForEach(filtredMarks(), id: \.self) { $eleveMark in
                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                    MarkView(eleveName : eleve.displayName,
                             maxMark   : exam.maxMark,
                             type      : $eleveMark.type,
                             mark      : $eleveMark.mark)
                }
            }
        } header: {
            Text("Notes")
        }
        .headerProminence(.increased)
    }

    private var isItemDeleted: Bool {
        !classe.exams.contains(where: { $0.id == exam.id })
    }

    var body: some View {
        List {
            if !isSearching {
                // nom
                name

                // date
                DatePicker("Date", selection: $exam.date)
                    .labelsHidden()
                    .listRowSeparator(.hidden)
                    .environment(\.locale, Locale.init(identifier: "fr_FR"))

                // barême
                Stepper(value : $exam.maxMark,
                        in    : 1 ... 20,
                        step  : 1) {
                    HStack {
                        Text("Barême")
                        Spacer()
                        Text("\(exam.maxMark) points")
                            .foregroundColor(.secondary)
                    }
                }

                // coefficient
                Stepper(value : $exam.coef,
                        in    : 0.0 ... 5.0,
                        step  : 0.25) {
                    HStack {
                        Text("Coefficient")
                        Spacer()
                        Text("\(exam.coef.formatted(.number.precision(.fractionLength(2))))")
                            .foregroundColor(.secondary)
                    }
                }
            }

            // notes
            markList
        }
        .searchable(text      : $searchString,
                    placement : .navigationBarDrawer(displayMode : .automatic),
                    prompt    : "Nom ou Prénom de l'élève")
        .disableAutocorrection(true)
        #if os(iOS)
        .navigationTitle("Évaluation")
        #endif
        .disabled(isItemDeleted)
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Évaluation supprimée. Sélectionner une évaluation.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Methods

    private func filtredMarks() -> Binding<[EleveMark]> {

        Binding<[EleveMark]>(
            get: {
                self.exam.marks
                    .filter { eleveMark in
                        if searchString.isNotEmpty {
                            let string = searchString.lowercased()
                            if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                                return eleve.name.familyName!.lowercased().contains(string) ||
                                eleve.name.givenName!.lowercased().contains(string)
                            } else {
                                return false
                            }
                        } else {
                            return true
                        }
                    }
            },
            set: { items in
                for eleveMark in items {
                    if let index = self.exam.marks.firstIndex(where: { $0.eleveId == eleveMark.eleveId }) {
                        self.exam.marks[index] = eleveMark
                    }
                }
            }
        )
    }
}

struct ExamEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ExamEditor(classe         : .constant(TestEnvir.classeStore.items.first!),
                       exam           : .constant(Exam()))
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")

            ExamEditor(classe         : .constant(TestEnvir.classeStore.items.first!),
                       exam           : .constant(Exam()))
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
        }
    }
}
