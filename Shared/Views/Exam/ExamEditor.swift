//
//  ExamEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 13/05/2022.
//

import SwiftUI

struct ExamEditor: View {
    @Binding
    var exam   : Exam

    @State
    private var searchString: String = ""

    @Environment(\.isSearching)
    private var isSearching

    var body: some View {
        List {
            if !isSearching {
                ExamDetail(exam: $exam)
            }
            // notes
            MarkListView(exam: $exam, searchString: searchString)
        }
        .searchable(text      : $searchString,
                    placement : .navigationBarDrawer(displayMode : .automatic),
                    prompt    : "Nom, Prénom ou n° de groupe")
        .disableAutocorrection(true)
        #if os(iOS)
        .navigationTitle("Évaluation")
        #endif
    }
}

struct MarkListView : View {
    @Binding
    var exam: Exam

    var searchString: String

    @EnvironmentObject
    private var eleveStore: EleveStore

    var body: some View {
        Section {
            ForEach(filtredMarks()) { $eleveMark in
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

    // MARK: - Methods

    private func filtredMarks() -> Binding<[EleveMark]> {
        Binding<[EleveMark]>(
            get: {
                self.exam.marks
                    .filter { eleveMark in
                        if searchString.isNotEmpty {
                            if searchString.containsOnlyDigits {
                                // filtrage sur numéro de groupe
                                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                                    let groupNum = Int(searchString)!
                                    return eleve.group == groupNum
                                } else {
                                    return false
                                }

                            } else {
                                // filtrage sur Nom ou Prénom
                                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                                    let string = searchString.lowercased()
                                    return eleve.name.familyName!.lowercased().contains(string) ||
                                    eleve.name.givenName!.lowercased().contains(string)
                                } else {
                                    return false
                                }
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

struct ExamDetail : View {
    @Binding
    var exam: Exam

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

    var body: some View {
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
}

struct ExamEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ExamEditor(exam: .constant(Exam()))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPad mini (6th generation)")

            ExamEditor(exam: .constant(Exam()))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPhone Xs")
        }
    }
}
