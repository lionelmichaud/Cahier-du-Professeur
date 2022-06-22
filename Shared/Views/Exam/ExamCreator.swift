//
//  ExamCreator.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/06/2022.
//

import SwiftUI

struct ExamCreator: View {
    let elevesId   : [UUID] = []
    let addNewItem : (Exam) -> Void
    @State
    private var newExam: Exam
    @FocusState
    private var isSujetFocused: Bool
    @Environment(\.dismiss) private var dismiss

    private var name: some View {
        HStack {
            Image(systemName: "doc.plaintext")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)

            // sujet
            TextField("Sujet de l'évaluation", text: $newExam.sujet)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
                .focused($isSujetFocused)
        }
    }

    var body: some View {
        Form {
            // nom
            name

            // date
            DatePicker("Date", selection: $newExam.date)
                .labelsHidden()
                .listRowSeparator(.hidden)
                .environment(\.locale, Locale.init(identifier: "fr_FR"))

            // barême
            Stepper(value : $newExam.maxMark,
                    in    : 1 ... 20,
                    step  : 1) {
                HStack {
                    Text("Barême")
                    Spacer()
                    Text("\(newExam.maxMark) points")
                        .foregroundColor(.secondary)
                }
            }

            // coefficient
            Stepper(value : $newExam.coef,
                    in    : 0.0 ... 5.0,
                    step  : 0.25) {
                HStack {
                    Text("Coefficient")
                    Spacer()
                    Text("\(newExam.coef.formatted(.number.precision(.fractionLength(2))))")
                        .foregroundColor(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Ok") {
                    // Ajouter le nouvel établissement
                    withAnimation {
                        addNewItem(newExam)
                    }
                    dismiss()
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Nouvelle Évaluation")
        #endif
        .onAppear {
            isSujetFocused = true
        }
    }

    // MARK: - Initializer

    init(elevesId   : [UUID] = [],
         addNewItem : @escaping (Exam) -> Void) {
        self.addNewItem = addNewItem
        self._newExam = State(initialValue: Exam(elevesId: elevesId))
    }

}

struct ExamCreator_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            ExamCreator(elevesId: [UUID()],
                        addNewItem: { _ in })
        }
    }
}
