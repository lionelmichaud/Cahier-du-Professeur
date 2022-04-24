//
//  EleveBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI

struct EleveBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore

    var body: some View {
        List {
            if schoolStore.items.isEmpty {
                Text("Aucun établissement")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.items.sorted(by: { $0.niveau.rawValue < $1.niveau.rawValue })) { school in
                    if school.nbOfClasses != 0 {
                        Section() {
                            // pour chaque Classe
                            EleveBrowserSchoolSubiew(school: school)
                        } header: {
                            Text(school.displayString)
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        .navigationTitle("Élèves")
    }
}

struct EleveBrowserSchoolSubiew : View {
    let school: School

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore

    var body: some View {
        if classeStore.items.isEmpty {
            Text("Aucune classe")
        } else {
            ForEach(classeStore.classes(dans: school)) { $classe in
                // pour chaque Elève
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
                            .swipeActions {
                                // supprimer un élève
                                Button(role: .destructive) {
                                    withAnimation {
                                        // supprimer l'élève et tous ses descendants
                                        // puis retirer l'élève de la classe auquelle il appartient
                                        ClasseManager().retirer(eleve       : eleve,
                                                                deClasse    : &classe,
                                                                eleveStore  : eleveStore,
                                                                observStore : observStore,
                                                                colleStore  : colleStore)
                                    }
                                } label: {
                                    Label("Supprimer", systemImage: "trash")
                                }
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
