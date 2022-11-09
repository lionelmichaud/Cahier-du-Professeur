//
//  RoomList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/11/2022.
//

import SwiftUI
import HelpersView

/// Vue de la liste des salles de classe de l'établissement
struct RoomList: View {
    @Binding
    var school: School

    @EnvironmentObject
    private var classeStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

//    @State
//    private var isShowingDeleteRoomDialog = false

    @State
    private var alertItem: AlertItem?

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
                self.alertItem = AlertItem(
                    title         : Text("Supprimer cette salle de classe?"),
                    message       : Text("Cette action supprimera le plan de la salle de classe ainsi que toutes les places associées.\n") +
                    Text("Cette action supprimera aussi la salle de classe elle-même.\n") +
                    Text("Cette action ne peut pas être annulée."),
                    primaryButton  : .destructive(Text("Supprimer"),
                                                  action: {
                                                      indexSet.forEach { roomIndex in
                                                          RoomManager.deleteRoomPlan(
                                                            de: &school.rooms[roomIndex],
                                                            dans: school,
                                                            classeStore: classeStore,
                                                            eleveStore: eleveStore)
                                                      }
                                                      school.rooms.remove(atOffsets: indexSet)
                                                  }),
                    secondaryButton: .cancel()
                )
            }
            .onMove { fromOffsets, toOffset in
                school.rooms.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }
            .alert(item: $alertItem, content: newAlert)

        } header: {
            Text("Salles de classe (\(school.nbOfRessources))")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
    }
}

//struct RoomList_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomList()
//    }
//}
