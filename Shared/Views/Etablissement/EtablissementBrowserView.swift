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
            ForEach($etabStore.items) { $etablissement in
                NavigationLink {
                    EtablissementEditor(etablissement: $etablissement)
                } label: {
                    EtablissementRow(etablissement: etablissement)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        etabStore.delete(etablissement,
                                         classes : classeStore,
                                         eleves  : eleveStore,
                                         observs : observStore,
                                         colles  : colleStore)
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
                }
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
        NavigationView {
            EtablissementBrowserView()
                .environmentObject(EtablissementStore.exemple)
                .environmentObject(ClasseStore.exemple)
                .environmentObject(EleveStore.exemple)
                .environmentObject(ColleStore.exemple)
                .environmentObject(ObservationStore.exemple)
        }
    }
}
