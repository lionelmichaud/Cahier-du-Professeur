//
//  SchoolDetail.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI
import HelpersView

struct SchoolDetail: View {
    @Binding
    var school    : School
    let isEditing : Bool
    let isNew     : Bool
    @Binding
    var isModified: Bool

    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewClasse = false
    @State
    private var newClasse = Classe.exemple
    @FocusState
    private var isNameFocused: Bool

    var heures: Double {
        SchoolManager().heures(dans: school, classeStore: classeStore)
    }

    var body: some View {
        List {
            // nom de l'établissement
            HStack {
                Image(systemName: school.niveau == .lycee ? "building.2" : "building")
                    .imageScale(.large)
                    .foregroundColor(school.niveau == .lycee ? .mint : .orange)
                if isNew || isEditing {
                    TextField("Nouvel établissement", text: $school.nom)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                        .focused($isNameFocused)
                } else {
                    Text(school.displayString)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowSeparator(.hidden)

            // type d'établissement
            if isNew || isEditing {
                CasePicker(pickedCase: $school.niveau,
                           label: "Type d'établissement")
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            // classes dans l'établissement
            if !isNew {
                // titre
                HStack {
                    Text(school.classesLabel)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(heures.formatted(.number.precision(.fractionLength(1)))) h")
                        .font(.title3)
                        .fontWeight(.bold)
                }

                // édition de la liste des classes
                ForEach(classeStore.sortedClasses(dans: school)) { $classe in
                    NavigationLink {
                        ClasseEditor(school : $school,
                                     classe : $classe,
                                     isNew  : false)
                    } label: {
                        SchoolClasseRow(classe: classe)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        isModified = true
                        deleteClasse(atIndex: index)
                    }
                })
                .onMove(perform: moveClasse)

                // ajouter une classe
                Button {
                    isModified = true
                    newClasse = Classe(niveau: .n6ieme, numero: 1)
                    isAddingNewClasse = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Ajouter une classe")
                    }
                }
                .buttonStyle(.borderless)
            }
        }
        #if os(iOS)
        .navigationTitle("Etablissement")
        #endif
        .onAppear {
            isNameFocused = isNew
        }
        .sheet(isPresented: $isAddingNewClasse) {
            NavigationView {
                ClasseEditor(school : $school,
                             classe : $newClasse,
                             isNew  : true)
            }
        }
    }

    private func moveClasse(from indexes: IndexSet, to destination: Int) {
        school.moveClasse(from: indexes, to: destination)
    }

    func deleteClasse(atIndex: Int) {
        SchoolManager().retirer(classeIndex : atIndex,
                                deSchool    : &school,
                                classeStore : classeStore,
                                eleveStore  : eleveStore,
                                observStore : observStore,
                                colleStore  : colleStore)
    }
}

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            SchoolDetail(school    : .constant(TestEnvir.schoolStore.items.first!),
                         isEditing : false,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDisplayName("Display")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            SchoolDetail(school    : .constant(TestEnvir.schoolStore.items.first!),
                         isEditing : true,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDisplayName("Edit")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewInterfaceOrientation(.portraitUpsideDown)
            SchoolDetail(school    : .constant(TestEnvir.schoolStore.items.first!),
                         isEditing : false,
                         isNew     : true,
                         isModified: .constant(false))
            .previewDisplayName("New")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
        }
    }
}
