//
//  ExamDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 13/05/2022.
//

import SwiftUI
import HelpersView

struct ExamDetail: View {
    @Binding
    var exam      : Exam
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool
    @FocusState
    private var isSujetFocused: Bool

    var name: some View {
        HStack {
            Image(systemName: "doc.plaintext")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)

            if isNew || isEditing {
                // sujet
                TextField("Sujet de l'évaluation", text: $exam.sujet)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
                    .focused($isSujetFocused)

            } else {
                Text(exam.sujet)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    var date: some View {
        if isNew || isEditing {
            DatePicker("Date", selection: $exam.date)
                .labelsHidden()
                .listRowSeparator(.hidden)
                .environment(\.locale, Locale.init(identifier: "fr_FR"))
        } else {
            Text("Le " + exam.date.stringLongDateTime)
        }
    }

    var body: some View {
        List {
            // nom
            name
            // date
            date
        }
        #if os(iOS)
        .navigationTitle("Évaluation")
        #endif
        .onAppear {
            isSujetFocused = isNew
        }
    }
}

struct ExamDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ExamDetail(exam      : .constant(Exam()),
                       isEditing : false,
                       isNew     : true,
                       isModified: .constant(false))
                .previewDisplayName("Display")
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDisplayName("New")

            ExamDetail(exam      : .constant(Exam()),
                       isEditing : false,
                       isNew     : false,
                       isModified: .constant(false))
            .previewDevice("iPhone Xs")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDisplayName("Display")
        }
    }
}
