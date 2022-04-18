//
//  EtablissementDetail.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct EtablissementDetail: View {
    @Binding var etablissement: Etablissement
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    let isEditing: Bool

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: etablissement.niveau == .lycee ? "building.2" : "building")
                    .imageScale(.large)
                    .foregroundColor(etablissement.niveau == .lycee ? .mint : .orange)
                if isEditing {
                    TextField("Nouvel établissement", text: $etablissement.nom)
                        .font(.title2)
                } else {
                    Text(etablissement.displayString)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowSeparator(.hidden)

            // Type d'établissement
            if isEditing {
                CasePicker(pickedCase: $etablissement.niveau,
                           label: "Type d'établissement")
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            // classes
            Text("Classes")
                .fontWeight(.bold)

            if etablissement.nbOfClasses == 0 {
                Text("Auncune classe dans cet établissement")
                    .foregroundColor(.secondary)
            } else {
                ForEach($etablissement.classes) { $item in
                    ClassRow(classe: $item, isEditing: isEditing)
                }
                .onDelete(perform: { indexSet in
                    classeStore
                        .delete(etablissement.classes[indexSet.first!],
                                eleves  : eleveStore,
                                observs : observStore,
                                colles  : colleStore)
                })
            }

            Button {
                let newClasse = Classe(niveau: .n6ieme, numero: 0)
                classeStore.add(newClasse)
                withAnimation {
                    EtablissementManager()
                        .ajouter(classe: newClasse,
                                 aEtablissement: &etablissement)
                }
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Ajouter une classe")
                }
            }
            .buttonStyle(.borderless)
        }
        #if os(iOS)
        .navigationTitle("Etablissement")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct EtablissementDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            EtablissementDetail(etablissement: .constant(TestEnvir.etabStore.items.first!), isEditing: true)
                //.environmentObject(TestEnvir.etabStore)
                .environmentObject(TestEnvir.classStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colStore)
                .environmentObject(TestEnvir.obsStore)
            EtablissementDetail(etablissement: .constant(TestEnvir.etabStore.items.first!), isEditing: false)
                //.environmentObject(TestEnvir.etabStore)
                .environmentObject(TestEnvir.classStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colStore)
                .environmentObject(TestEnvir.obsStore)
        }
    }
}
