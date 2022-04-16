//
//  EtablissementBrowserView.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct EtablissementBrowserView: View {
    @EnvironmentObject var etabStore   : EtablissementStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewEtab = false
    @State
    private var newEtab = Etablissement()

    var body: some View {
        List {
            ForEach(NiveauEtablissement.allCases) { niveau in
                if etabStore.sorted(niveau: niveau).isNotEmpty {
                    Section {
                        ForEach(etabStore.sorted(niveau: niveau)) { $etablissement in
                            NavigationLink {
                                EtablissementEditor(etablissement: $etablissement)
                            } label: {
                                EtablissementRow(etablissement: etablissement)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        etabStore.delete(etablissement,
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
                    etabStore  : etabStore,
                    classStore : classeStore,
                    eleveStore : eleveStore,
                    obsStore   : observStore,
                    colStore   : colleStore)
            } label: {
                Text("Test").foregroundColor(.primary)
            }

        }
        //.listStyle(.sidebar)
        .navigationTitle("Etabissements")
        .navigationViewStyle(.columns)
        .toolbar {
            ToolbarItem {
                Button {
                    newEtab = Etablissement()
                    isAddingNewEtab = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingNewEtab) {
            NavigationView {
                EtablissementEditor(etablissement: $newEtab, isNew: true)
            }
        }
    }
}

struct EtablissementBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EtablissementBrowserView()
                .environmentObject(TestEnvir.etabStore)
                .environmentObject(TestEnvir.classStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colStore)
                .environmentObject(TestEnvir.obsStore)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
