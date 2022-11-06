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
                Button("Dissocier", role: .destructive) {
                    withAnimation {
                        // TODO: - Dissocier les classes utilisant cette salle
                        school.rooms.remove(atOffsets: indexSet)
                    }
                }
            } message: {
                Text("Cette action ne peut pas être annulée.")
            }

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
