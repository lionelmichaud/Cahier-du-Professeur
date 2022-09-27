//
//  PapView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 26/09/2022.
//

import SwiftUI

struct PapView: View {
    @Binding var isModified: Bool
    @Binding var trouble: TroubleDys?

    @Environment(\.horizontalSizeClass)
    private var hClass

    var body: some View {
        DisclosureGroup(isExpanded: .constant(true)) {
            Text(trouble!.displayString)
            if trouble!.additionalTime {
                Text("Evaluation: 1/3 de temps aditionel")
            }
        } label: {
            Text("P.A.P.")
                .font(.headline)
                .fontWeight(.bold)
        }
        .listRowSeparator(.hidden)
        .onChange(of: trouble) {newValue in
            isModified = true
        }
    }
}

struct PapView_Previews: PreviewProvider {
    static var previews: some View {
        PapView(isModified: .constant(false),
                trouble: .constant(.dyslexie))
    }
}
