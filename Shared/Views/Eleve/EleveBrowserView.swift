//
//  EleveBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore

    var body: some View {
        List {
            // pour chaque Etablissement
            ForEach(schoolStore.items.sorted(by: { $0.niveau.rawValue < $1.niveau.rawValue })) { school in
                if school.nbOfClasses != 0 {
                    Section() {
                        // pour chaque Classe
                        ForEach(classeStore.classes(dans: school)) { $classe in
                            // pour chaque Elève
                            if classe.nbOfEleves != 0 {
                                ClasseSubview(classe: $classe,
                                              school: school)
                            }
                        }
                    } header: {
                        Text(school.displayString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationTitle("Élèves")
    }
}

struct ClasseSubview : View {
    @Binding var classe: Classe
    let school: School

    @EnvironmentObject private var eleveStore: EleveStore

    var body: some View {
        if classe.nbOfEleves != 0 {
            DisclosureGroup() {
                ForEach(eleveStore.eleves(dans: classe)) { $eleve in
                    NavigationLink {
                        EleveEditor(classe : .constant(classe),
                                    eleve  : $eleve,
                                    isNew  : false)
                    } label: {
                        EleveBrowserRow(eleve: eleve)
                    }
                }
            } label: {
                Text(classe.displayString)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
            }
        }
    }
}


struct EleveBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EleveBrowserView()
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
