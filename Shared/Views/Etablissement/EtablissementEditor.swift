//
//  EtablissementEditor.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct EtablissementEditor: View {
    @Binding var etablissement: Etablissement
    var isNew = false

    @State private var isDeleted = false
    @EnvironmentObject var etabStore   : EtablissementStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore
    @EnvironmentObject var colleStore  : ColleStore
    @EnvironmentObject var observStore : ObservationStore
    @Environment(\.dismiss) private var dismiss

    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the niveau changes and puts the établissement in a different section.
    @State private var itemCopy = Etablissement()
    @State private var isEditing = false

    private var isItemDeleted: Bool {
        !etabStore.exists(etablissement) && !isNew
    }

    var body: some View {
        VStack {
            EtablissementDetail(etablissement: $itemCopy,
                                isEditing: isNew ? true : isEditing)
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
                                    etabStore.add(itemCopy)
                                }
                                dismiss()
                            } else {
                                // Appliquer les modifications faites à l'établissement
                                if isEditing && !isDeleted {
                                    print("Done, saving any changes to \(etablissement.displayString).")
                                    withAnimation {
                                        etablissement = itemCopy // Put edits (if any) back in the store.
                                    }
                                }
                                isEditing.toggle()
                            }
                        } label: {
                            Text(isNew ? "Ajouter" : (isEditing ? "Ok" : "Modifier"))
                        }
                    }
                }
                .onAppear {
                    itemCopy = etablissement // Grab a copy in case we decide to make edits.
                }
                .disabled(isItemDeleted)

            if isEditing && !isNew {
                Button(
                    role: .destructive,
                    action: {
                        isDeleted = true
                        withAnimation {
                            etabStore.delete(etablissement,
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
}

struct EtablissementEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EmptyView()
            EtablissementEditor(etablissement: .constant(TestEnvir.etabStore.items.first!), isNew: false)
                .environmentObject(TestEnvir.etabStore)
                .environmentObject(TestEnvir.classStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colStore)
                .environmentObject(TestEnvir.obsStore)
            //.previewInterfaceOrientation(.landscapeRight)
        }
    }
}
