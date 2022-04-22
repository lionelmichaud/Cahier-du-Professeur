//
//  SchoolEditor.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct SchoolEditor: View {
    @Binding var school: School
    var isNew = false

    @EnvironmentObject var schoolStore   : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy   = School()
    // true si le mode édition est engagé
    @State private var isEditing  = false
    // true les modifs faites en mode édition sont sauvegardées
    @State private var isSaved    = false
    // true si des modifiction sont faites hors du mode édition
    @State private var isModified = false
    // true si l'item va être détruit
    @State private var isDeleted = false

    private var isItemDeleted: Bool {
        !schoolStore.exists(school) && !isNew
    }

    var body: some View {
        VStack {
            SchoolDetail(school    : $itemCopy,
                         isEditing : isEditing,
                         isNew     : isNew,
                         isModified: $isModified)
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
                                // Ajouter le nouvel établissement
                                withAnimation {
                                    schoolStore.add(itemCopy)
                                }
                                dismiss()
                            } else {
                                // Appliquer les modifications faites à l'établissement
                                if isEditing && !isDeleted {
                                    print("Done, saving any changes to \(school.displayString).")
                                    withAnimation {
                                        school = itemCopy // Put edits (if any) back in the store.
                                        isSaved = true
                                    }
                                }
                                isEditing.toggle()
                            }
                        } label: {
                            Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                        }
                    }
                }
                .onDisappear {
                    if isModified && !isSaved {
                        // Appliquer les modifications faites à l'établissement hors du mode édition
                        school = itemCopy
                    }
                }
                .disabled(isItemDeleted)

            if isEditing && !isNew {
                Button(
                    role: .destructive,
                    action: {
                        isDeleted = true
                        withAnimation {
                            schoolStore.delete(school,
                                             classes : classeStore,
                                             eleves  : eleveStore,
                                             observs : observStore,
                                             colles  : colleStore)
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
                Text("Etablissement supprimé. Sélectionner un établissement.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    init(school: Binding<School>,
         isNew: Bool = false) {
        self.isNew = isNew
        self._school = school
        self._itemCopy = State(initialValue: school.wrappedValue)
    }
}

struct SchoolEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EmptyView()
            SchoolEditor(school : .constant(TestEnvir.schoolStore.items.first!),
                         isNew  : false)
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            //.previewInterfaceOrientation(.landscapeRight)
        }
    }
}
