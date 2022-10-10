//
//  ClasseSidebarView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import SwiftUI

struct ClasseSplitView: View {
    @EnvironmentObject private var navigationModel : NavigationModel

    var body: some View {
        NavigationSplitView(
            columnVisibility: $navigationModel.columnVisibility
        ) {
            ClasseSidebarView()
        } detail: {
            NavigationStack {
                ClasseEditor()
                    .navigationDestination(for: ClasseSubview.self) { classeSubview in
                        switch classeSubview.subviewType {
                            case .groups:
                                GroupsView(classe: classeSubview.classe)

                            case .trombinoscope:
                                TrombinoscopeView(classe : classeSubview.classe)
                        }
                    }
                    .navigationDestination(for: ExamSubview.self) { examSubview in
                        ExamEditor(exam: examSubview.exam)
                    }
            }
        }
    }
}

struct ClasseSplitView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseSplitView()
                .environmentObject(NavigationModel())
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPad mini (6th generation)")

            ClasseSplitView()
                .environmentObject(NavigationModel())
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPhone 13")
        }
    }
}
