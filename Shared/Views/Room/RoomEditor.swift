//
//  RoomEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI

struct RoomEditor: View {
    @Binding
    var classe: Classe

    @EnvironmentObject private var schoolStore : SchoolStore

    @State
    private var isShowingDissociateDialog = false

    // MARK: - ComputedProperties

    private var school: School? {
        guard let schoolId = classe.schoolId else {
            return nil
        }
        return schoolStore.item(withID: schoolId)
    }

    private var room: Room? {
        guard let school, let roomId = classe.roomId else {
            return nil
        }
        return RoomManager.room(withId: roomId, in: school)
    }

    private var roomName: String {
        room?.name ?? ""
    }

   private var associateMenu: some View {
        Menu {
            ForEach(school!.rooms) { room in
                Button(room.name) {
                    withAnimation {
                        classe.roomId = room.id
                    }
                }
            }
        } label: {
            Label("Associer", systemImage: "plus.circle.fill")
        }
    }

    var body: some View {
        Group {
            if classe.hasAssociatedRoom {
                // TODO: - Gérer ici la mise à jour de la photo par drag and drop
                if let roomPlanURL = room?.planURL {
                    LoadableImage(imageUrl: roomPlanURL,
                                  placeholderImage: .constant(Image(systemName: "questionmark.app.dashed")))
                } else {
                    Text("Plan de salle introuvable")
                        .foregroundStyle(.secondary)
                        .font(.title)
                }
            } else {
                VStack {
                    Text("Aucune salle de classe")
                    Text("Définir une salle de classe")
                }
                .foregroundStyle(.secondary)
                .font(.title)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if classe.hasAssociatedRoom {
                    /// Dissocier la classe de la salle de classe
                    Button(role: .destructive) {
                        isShowingDissociateDialog.toggle()
                    } label: {
                        Label("Dissocier", systemImage: "minus.circle.fill")
                    }
                    .confirmationDialog("Dissocier la classe de cette salle de cours?",
                                        isPresented: $isShowingDissociateDialog) {
                        Button("Dissocier", role: .destructive) {
                            withAnimation {
                                classe.roomId = nil
                            }
                        }
                    } message: {
                        Text("Cette action ne peut pas être annulée.")
                    }
                } else if school != nil {
                    /// associer la classe à une salle de classe
                    associateMenu
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Salle \(roomName)")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct RoomEditor_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                RoomEditor(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomEditor(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
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
