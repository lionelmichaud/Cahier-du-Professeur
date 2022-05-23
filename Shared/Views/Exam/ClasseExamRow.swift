//
//  ClasseExamRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 12/05/2022.
//

import SwiftUI
import HelpersView

struct ClasseExamRow: View {
    let exam: Exam

    var body: some View {
        HStack {
            Image(systemName: "doc.plaintext")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 5) {
                Text(exam.sujet)
                HStack {
                    Text(exam.date.stringLongDate)
                    Spacer()
                    Text("sur \(exam.maxMark) points")
                    Spacer()
                    Text("coef \(exam.coef.formatted(.number.precision(.fractionLength(2))))")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            //.fontWeight(.semibold)
        }
    }
}

struct ClasseExamRow_Previews: PreviewProvider {
    static var previews: some View {
        ClasseExamRow(exam: Exam(id: UUID(),
                                 sujet: "Les automatismes en technologie",
                                 maxMark: 20,
                                 date: Date.now,
                                 marks: []))
    }
}
