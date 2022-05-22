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
    @State
    private var noteIsExpanded = false
    @FocusState
    private var isNameFocused: Bool
    @Preference(\.schoolAnnotation)
    var schoolAnnotation

    var heures: Double {
        SchoolManager().heures(dans: school, classeStore: classeStore)
    }

    var name: some View {
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
    }

    var annotation: some View {
        DisclosureGroup(isExpanded: $noteIsExpanded) {
            TextEditor(text: $school.annotation)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                .frame(minHeight: 80)
        } label: {
            Text("Annotation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .onChange(of: school.annotation) {newValue in
            isModified = true
        }
    }

    var classeList: some View {
        Section {
            // ajouter une classe
            Button {
                isModified = true
                newClasse = Classe(niveau: .n6ieme, numero: 1)
                isAddingNewClasse = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter une classe")
                }
            }
            .buttonStyle(.borderless)

            // édition de la liste des classes
            ForEach(classeStore.sortedClasses(dans: school)) { $classe in
                NavigationLink {
                    ClasseEditor(school : $school,
                                 classe : $classe,
                                 isNew  : false)
                } label: {
                    SchoolClasseRow(classe: classe)
                }
                .swipeActions {
                    // supprimer un élève
                    Button(role: .destructive) {
                        withAnimation {
                            // supprimer l'élève et tous ses descendants
                            // puis retirer l'élève de la classe auquelle il appartient
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

                    // flager un élève
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
                Text(school.classesLabel)
                Spacer()
                Text("\(heures.formatted(.number.precision(.fractionLength(1)))) h")
            }
            .headerProminence(.increased)
            //.font(.headline)
        }
    }

    var body: some View {
        List {
            // nom de l'établissement
            name

            // type d'établissement
            if isNew || isEditing {
                CasePicker(pickedCase: $school.niveau,
                           label: "Type d'établissement")
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            // classes dans l'établissement
            if !isNew {
                // note sur la classe
                if schoolAnnotation {
                    annotation
                }
                // édition de la liste des classes
                classeList
            }
        }
        #if os(iOS)
        .navigationTitle("Etablissement")
        #endif
        .onAppear {
            isNameFocused = isNew
            noteIsExpanded = school.annotation.isNotEmpty
        }
        .sheet(isPresented: $isAddingNewClasse) {
            NavigationView {
                ClasseEditor(school : $school,
                             classe : $newClasse,
                             isNew  : true)
            }
        }
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
