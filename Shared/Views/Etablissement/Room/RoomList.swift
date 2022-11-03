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

    var body: some View {
        Section {
            // ajouter une évaluation
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

            // édition de la liste des examen
            ForEach($school.rooms) { $room in
                RoomCreator(room: $room, school: school)
            }
            .onDelete { indexSet in
                // TODO: - Dissocier les classes utilisant cette salle
                school.rooms.remove(atOffsets: indexSet)
            }
            .onMove { fromOffsets, toOffset in
                school.rooms.move(fromOffsets: fromOffsets, toOffset: toOffset)
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
