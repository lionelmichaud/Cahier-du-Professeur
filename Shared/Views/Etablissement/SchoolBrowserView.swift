//
//  SchoolBrowserView.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct SchoolBrowserView: View {
    @EnvironmentObject var schoolStore : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewEtab = false
    @State
    private var newEtab = School()

    var body: some View {
        List {
            ForEach(NiveauSchool.allCases) { niveau in
                if !schoolStore.sorted(niveau: niveau).isEmpty {
                    Section {
                        ForEach(schoolStore.sorted(niveau: niveau)) { $school in
                            NavigationLink {
                                SchoolEditor(school: $school)
                            } label: {
                                SchoolRow(school: school)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        schoolStore.delete(school,
                                                         classes : classeStore,
                                                         eleves  : eleveStore,
                                                         observs : observStore,
                                                         colles  : colleStore)
                                    }
                                } label: {
                                    Label("Supprimer", systemImage: "trash")
                                }
                            }
                        }
                    } header: {
                        Text(niveau.displayString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                }
            }
            Button {
                TestEnvir.populateWithFakes(
                    schoolStore : schoolStore,
                    classeStore : classeStore,
                    eleveStore  : eleveStore,
                    observStore : observStore,
                    colleStore  : colleStore)
            } label: {
                Text("Test").foregroundColor(.primary)
            }
        }
        //.listStyle(.sidebar)
        .navigationTitle("Etabissements")
        //.navigationViewStyle(.columns)
        .toolbar {
            ToolbarItem {
                Button {
                    newEtab = School()
                    isAddingNewEtab = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingNewEtab) {
            NavigationView {
                SchoolEditor(school: $newEtab, isNew: true)
            }
        }
    }
}

struct SchoolBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            SchoolBrowserView()
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
