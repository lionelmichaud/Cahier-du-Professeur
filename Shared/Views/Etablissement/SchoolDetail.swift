//
//  SchoolDetail.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 09/10/2022.
//

import SwiftUI
import os
import HelpersView
import Files

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "SchoolDetail")

struct SchoolDetail: View {
    @Binding
    var school: School

    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var schoolStore     : SchoolStore
    @EnvironmentObject private var classeStore     : ClasseStore
    @EnvironmentObject private var eleveStore      : EleveStore
    @EnvironmentObject private var colleStore      : ColleStore
    @EnvironmentObject private var observStore     : ObservationStore

    @State
    private var noteIsExpanded = false

    @State
    private var alertItem: AlertItem?

    @Preference(\.schoolAnnotationEnabled)
    private var schoolAnnotation

    // MARK: - Computed Properties

    /// Vue du nom de l'établissement
    private var name: some View {
        HStack {
            Image(systemName: school.niveau == .lycee ? "building.2" : "building")
                .imageScale(.large)
                .foregroundColor(school.niveau == .lycee ? .mint : .orange)
            TextField("Nouvel établissement", text: $school.nom)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
        }
        .listRowSeparator(.hidden)
    }

    private var selectedItemExists: Bool {
        guard let selectedSchool = navigationModel.selectedSchoolId else {
            return false
        }
        return schoolStore.contains(selectedSchool)
    }

    var body: some View {
        VStack {
            if selectedItemExists {
                // nom de l'établissement
                GroupBox {
                    name
                }
                .padding(.horizontal, 60)

                List {
                    // note sur la classe
                    if schoolAnnotation {
                        AnnotationView(isExpanded: $noteIsExpanded,
                                       annotation: $school.annotation)
                    }

                    // édition de la liste des classes
                    ClassList(school: $school)

                    // édition de la liste des événements
                    EventList(school: $school)

                    // édition de la liste des documents utiles
                    DocumentList(school: $school)

                    // édition de la liste des salles de classe
                    RoomList(school: $school)

                    // édition de la liste des ressources
                    RessourceList(school: $school)
                }
                #if os(iOS)
                .navigationTitle("Etablissement")
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .onAppear {
                    noteIsExpanded = school.annotation.isNotEmpty
                }
            } else {
                VStack(alignment: .center) {
                    Text("Aucun établissement sélectionné.")
                    Text("Sélectionner un établissement.")
                }
                .foregroundStyle(.secondary)
                .font(.title)
            }
        }
    }
}

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
                    .environmentObject(NavigationModel(selectedSchoolId: TestEnvir.schoolStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                SchoolDetail(school: .constant(TestEnvir.schoolStore.items.first!))
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
