//
//  ClassList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 31/10/2022.
//

import SwiftUI

struct ClassList: View {
    @Binding
    var school: School

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var classeStore     : ClasseStore
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State
    private var isAddingNewClasse = false

    // MARK: - Computed Properties

    private var heures: Double {
        SchoolManager().heures(dans: school, classeStore: classeStore)
    }

    var body: some View {
        Section {
            // ajouter une classe
            Button {
                isAddingNewClasse = true
            } label: {
                Label("Ajouter une classe", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderless)

            // édition de la liste des classes
            ForEach(classeStore.sortedClasses(dans: school)) { $classe in
                ClassBrowserRow(classe: classe)
                    .onTapGesture {
                        // Programatic Navigation
                        navigationModel.selectedTab      = .classe
                        navigationModel.selectedClasseId = classe.id
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

                        // flager une classe
                        Button {
                            withAnimation {
                                classe.isFlagged.toggle()
                            }
                        } label: {
                            if classe.isFlagged {
                                Label("Sans drapeau", systemImage: "flag.slash")
                            } else {
                                Label("Avec drapeau", systemImage: "flag.fill")
                            }
                        }.tint(.orange)
                    }
            }
        } header: {
            // titre
            HStack {
                Text("Classes (\(school.nbOfClasses))")
                Spacer()
                Text("\(heures.formatted(.number.precision(.fractionLength(1)))) h")
            }
            .font(.callout)
            .foregroundColor(.secondary)
            .fontWeight(.bold)
        }
        // Modal: ajout d'une nouvelle classe
        .sheet(isPresented: $isAddingNewClasse) {
            NavigationStack {
                ClassCreator(inSchool: $school)
            }
            .presentationDetents([.medium])
        }

    }
}

struct ClassList_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            List {
                ClassList(school: .constant(TestEnvir.schoolStore.items.first!))
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            List {
                ClassList(school: .constant(TestEnvir.schoolStore.items.first!))
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
