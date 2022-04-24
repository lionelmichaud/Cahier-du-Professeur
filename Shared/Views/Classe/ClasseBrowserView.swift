//
//  ClasseBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/04/2022.
//

import SwiftUI

struct ClasseBrowserView: View {
    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore

    var body: some View {
        List {
            if classeStore.items.isEmpty {
                Text("Aucune classe")
            } else {
                // pour chaque Etablissement
                ForEach(schoolStore.sorted()) { $school in
                    if school.nbOfClasses != 0 {
                        Section {
                            // pour chaque Classe
                            ClasseBrowserSchoolSubview(school: $school)
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
        .navigationTitle("Classes")
    }
}

struct ClasseBrowserSchoolSubview : View {
    @Binding var school: School

    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore

    var body: some View {
        ForEach(classeStore.classes(dans: school)) { $classe in
            NavigationLink {
                ClasseEditor(school : .constant(school),
                             classe : $classe,
                             isNew  : false)
            } label: {
                ClassBrowserRow(classe: classe)
            }
            .swipeActions {
                // supprimer une classe
                Button(role: .destructive) {
                    withAnimation {
                        // supprimer la classe et tous ses descendants
                        // puis retirer la classe de l'établissement auquelle elle appartient
                        SchoolManager().retirer(classe      : classe,
                                                deSchool    : &school,
                                                classeStore : classeStore,
                                                eleveStore  : eleveStore,
                                                observStore : observStore,
                                                colleStore  : colleStore)
                    }
                } label: {
                    Label("Supprimer", systemImage: "trash")
                }
            }
        }
    }
}

struct ClasseBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            ClasseBrowserView()
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
