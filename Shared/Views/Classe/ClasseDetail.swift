//
//  ClassDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import AppFoundation
import HelpersView

struct ClasseDetail: View {
    @Binding
    var classe    : Classe
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @State
    private var isAddingNewEleve = false
    @State
    private var newEleve = Eleve.exemple
    @FocusState
    private var isHoursFocused: Bool

    var eleveList: some View {
        Group {
            // titre
            Text(classe.elevesLabel)
                .font(.title3)
                .fontWeight(.bold)

            // édition de la liste des élèves
            ForEach(eleveStore.filteredSortedEleves(dans: classe)) { $eleve in
                NavigationLink {
                    EleveEditor(classe : $classe,
                                eleve  : $eleve,
                                isNew  : false)
                } label: {
                    ClasseEleveRow(eleve: eleve)
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

                    // flager un élève
                    Button {
                        withAnimation {
                            eleve.isFlagged.toggle()
                        }
                    } label: {
                        if eleve.isFlagged {
                            Label("Sans drapeau", systemImage: "flag.slash")
                        } else {
                            Label("Avec drapeau", systemImage: "flag.fill")
                        }
                    }.tint(.orange)
                }
            }

            // ajouter un élève
            Button {
                isModified = true
                newEleve = Eleve(sexe   : .male,
                                 nom    : "",
                                 prenom : "")
                isAddingNewEleve = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Ajouter un élève")
                }
            }
            .buttonStyle(.borderless)
        }
    }

    var body: some View {
        List {
            // nom
            HStack {
                Image(systemName: "person.3.fill")
                    .sfSymbolStyling()
                    .foregroundColor(classe.niveau.color)

                // niveau de cette classe
                if isNew {
                    CasePicker(pickedCase: $classe.niveau, label: "Niveau")
                        .pickerStyle(.menu)
                } else {
                    Text(classe.displayString)
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                // numéro de cette classe
                if isNew {
                    Picker("Numéro", selection: $classe.numero) {
                        ForEach(1...8, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.menu)
                }

                Spacer()

                // nombre d'heures d'enseignement pour cette classe
                if isNew || isEditing {
                    AmountEditView(label: "Heures",
                                   amount: $classe.heures,
                                   validity: .poz,
                                   currency: false)
                    .focused($isHoursFocused)
                    .frame(maxWidth: 150)
                } else {
                    Text("\(classe.heures.formatted(.number.precision(.fractionLength(1)))) h")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowSeparator(.hidden)

            // élèves dans la classe
            if !isNew {
                eleveList
            }
        }
        #if os(iOS)
        .navigationTitle("Classe")
        #endif
        .onAppear {
            isHoursFocused = isNew
        }
        .sheet(isPresented: $isAddingNewEleve) {
            NavigationView {
                EleveEditor(classe : $classe,
                            eleve  : $newEleve,
                            isNew  : true)
            }
        }
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ClasseDetail(classe   : .constant(TestEnvir.classeStore.items.first!),
                         isEditing : false,
                         isNew     : true,
                         isModified: .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDisplayName("NewClasse")

            ClasseDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                         isEditing : false,
                         isNew     : false,
                         isModified: .constant(false))
            .previewDevice("iPhone Xs")
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDisplayName("DisplayClasse")
        }
    }
}
