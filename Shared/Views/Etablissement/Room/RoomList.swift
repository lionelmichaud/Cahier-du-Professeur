//
//  RoomList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/11/2022.
//

import SwiftUI

/// Vue de la liste des salles de classe de l'établissement
struct RoomList: View {
    @Binding
    var school: School

    @EnvironmentObject
    private var classStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

    @State
    private var isShowingDeleteRoomDialog = false

    @State
    private var indexSet: IndexSet = []

    var body: some View {
        Section {
            /// Ajouter une nouvelle salle de classe
            Button {
                withAnimation {
                    school.rooms.insert(Room(), at: 0)
                }
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter une salle de classe")
                }
            }
            .buttonStyle(.borderless)

            /// Editer la liste des salles de classe
            ForEach($school.rooms) { $room in
                RoomCreator(room: $room, school: school)
            }
            .onDelete { indexSet in
                self.indexSet = indexSet
                isShowingDeleteRoomDialog.toggle()
            }
            .onMove { fromOffsets, toOffset in
                school.rooms.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }
            .confirmationDialog("Supprimer cette salle de classe?",
                                isPresented: $isShowingDeleteRoomDialog) {
                Button("Supprimer", role: .destructive) {
                    withAnimation {
                        // TODO: - A tester
                        indexSet.forEach { roomIndex in
                            var room = school.rooms[roomIndex]
                            // Dissocier les classes utilisant cette salle de classe
                            var classesUsingRoom = RoomManager.classesUsing(roomID      : room.id,
                                                                            dans        : school,
                                                                            classeStore : classStore)
                            for classeIdx in classesUsingRoom.indices {
                                classesUsingRoom[classeIdx].roomId = nil
                            }

                            // Supprimer tous les sièges positionnés sur le plan de la salle de classe.
                            // Tous les sièges seront libérés des élèves assis dessus dans l'ensemble des classes.
                            room.removeAllSeatsFromPlan(dans: school,
                                                        classStore: classStore,
                                                        eleveStore: eleveStore)

                            // Supprimer l'image du plan de la salle de classe
                            deletePlanFile(roomPlanURL: room.planURL)
                        }
                        school.rooms.remove(atOffsets: indexSet)
                    }
                }
            } message: {
                Text("Cette action supprimera le plan de la salle de classe ainsi que toutes les places associées.\n") +
                Text("Cette action supprimera aussi la salle de classe elle-même.\n") +
                Text("Cette action ne peut pas être annulée.")
            }

        } header: {
            Text("Salles de classe (\(school.nbOfRessources))")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
    }

    // MARK: - Methods

    func deletePlanFile(roomPlanURL: URL) {
        try? PersistenceManager().deleteFile(withURL: roomPlanURL)
    }
}

//struct RoomList_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomList()
//    }
//}
