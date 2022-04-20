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
    var school: School
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    let isEditing: Bool
    let isNew: Bool
    @Binding
    var isModified: Bool

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: school.niveau == .lycee ? "building.2" : "building")
                    .imageScale(.large)
                    .foregroundColor(school.niveau == .lycee ? .mint : .orange)
                if isNew || isEditing {
                    TextField("Nouvel établissement", text: $school.nom)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(school.displayString)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowSeparator(.hidden)

            // Type d'établissement
            if isNew || isEditing {
                CasePicker(pickedCase: $school.niveau,
                           label: "Type d'établissement")
//                .onChange(of: school.niveau,
//                          perform: { newValue in
//                    isModified = true
//                })
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            // classes
            Text("Classes (\(school.nbOfClasses))")
                .fontWeight(.bold)

            if school.nbOfClasses == 0 {
                Text("Auncune classe dans cet établissement")
                    .foregroundColor(.secondary)
            } else {
                ForEach(school.classesID, id: \.self) { classeId in
                    if let classe = classeStore.classe(withID: classeId) {
                        ClassRow(classe: classe)
                    } else {
                        Text("classe non trouvée: \(classeId)")
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        isModified = true
                        delete(classeIndex: index)
                    }
                })
            }

            Button {
                var newClasse = Classe(niveau: .n6ieme, numero: 0)
                isModified = true
                withAnimation {
                    SchoolManager()
                        .ajouter(classe  : &newClasse,
                                 aSchool : &school)
                }
                classeStore.add(newClasse)
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

    func delete(classeIndex: Int) {
        print("Avant:")
        print(String(describing: classeStore))
        print(String(describing: school))
        // supprimer la classe de la liste de classes
        classeStore.deleteClasse(withID: school.classesID[classeIndex])
        // supprimer la classe de l'établissement
        school.removeClasse(at: classeIndex)
        print("Après:")
        print(String(describing: classeStore))
        print(String(describing: school))
    }
}

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            SchoolDetail(school    : .constant(TestEnvir.etabStore.items.first!),
                         isEditing : false,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDisplayName("Display")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            SchoolDetail(school    : .constant(TestEnvir.etabStore.items.first!),
                         isEditing : true,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDisplayName("Edit")
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewInterfaceOrientation(.portraitUpsideDown)
            SchoolDetail(school    : .constant(TestEnvir.etabStore.items.first!),
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
