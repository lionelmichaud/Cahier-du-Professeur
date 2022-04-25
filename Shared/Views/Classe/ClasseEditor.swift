//
//  ClasseEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import HelpersView

struct ClasseEditor: View {
    @Binding
    var school: School
    @Binding
    var classe: Classe
    var isNew = false

    @EnvironmentObject private var schoolStore : SchoolStore
    @EnvironmentObject private var classeStore : ClasseStore
    @EnvironmentObject private var eleveStore  : EleveStore
    @EnvironmentObject private var colleStore  : ColleStore
    @EnvironmentObject private var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = Classe(niveau: .n6ieme, numero: 1)
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false
    @State private var alertItem : AlertItem?

    private var isItemDeleted: Bool {
        !classeStore.isPresent(classe) && !isNew
    }

    var body: some View {
        VStack {
            ClasseDetail(classe     : $itemCopy,
                         isEditing  : isEditing,
                         isNew      : isNew,
                         isModified : $isModified)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if isNew {
                        Button("Annuler") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem {
                    Button {
                        if isNew {
                            // Ajouter une nouvelle classe
                            if classeStore.exists(classe: itemCopy, in: school.id) {
                                self.alertItem = AlertItem(title         : Text("Ajout impossible"),
                                                           message       : Text("Cette classe existe déjà dans cet établissement"),
                                                           dismissButton : .default(Text("OK")))
                            } else {
                                withAnimation {
                                    SchoolManager()
                                        .ajouter(classe      : &itemCopy,
                                                 aSchool     : &school,
                                                 classeStore : classeStore)
                                }
                                dismiss()
                            }
                        } else {
                            // Appliquer les modifications faites à la classe
                            if isEditing && !isDeleted {
                                print("Done, saving any changes to \(classe.displayString).")
                                withAnimation {
                                    classe = itemCopy // Put edits (if any) back in the store.
                                }
                                isSaved = true
                            }
                            isEditing.toggle()
                        }
                    } label: {
                        Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                    }
                }
            }
            .onAppear {
                itemCopy   = classe
                isModified = false
                isSaved    = false
            }
            .onDisappear {
                if isModified && !isSaved {
                    // Appliquer les modifications faites à la classe hors du mode édition
                    classe     = itemCopy
                    isModified = false
                    isSaved    = true
                }
            }
            .disabled(isItemDeleted)

            // supprimer la classe
            if isEditing && !isNew {
                Button(
                    role: .destructive,
                    action: {
                        isDeleted = true
                        withAnimation {
                            // supprimer la classe et tous ses descendants
                            // retirer la classe de l'établissement auquelle elle appartient
                            classeStore.deleteClasse(classe,
                                                     eleveStore  : eleveStore,
                                                     observStore : observStore,
                                                     colleStore  : colleStore)
                        }
                        dismiss()
                    }, label: {
                        Label("Supprimer", systemImage: "trash.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    })
                .padding()
            }
        }
        .overlay(alignment: .center) {
            if isItemDeleted {
                Color(UIColor.systemBackground)
                Text("Classe supprimée. Sélectionner une classe.")
                    .foregroundStyle(.secondary)
            }
        }
        .alert(item: $alertItem, content: newAlert)
    }

    init(school: Binding<School>,
         classe: Binding<Classe>,
         isNew: Bool = false) {
        self.isNew = isNew
        self._school = school
        self._classe = classe
        self._itemCopy = State(initialValue: classe.wrappedValue)
    }
}

struct ClasseEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationView {
                EmptyView()
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationView {
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")

            NavigationView {
                ClasseEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                             classe : .constant(TestEnvir.classeStore.items.first!),
                             isNew  : false)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone Xs")
        }
    }
}
