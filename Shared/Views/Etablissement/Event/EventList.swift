//
//  EventList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/11/2022.
//

import SwiftUI

/// Vue de la liste des événements de l'établissement
struct EventList: View {
    @Binding
    var school: School

    var body: some View {
        Section {
            // ajouter une évaluation
            Button {
                withAnimation {
                    school.events.insert(Event(), at: 0)
                }
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter un événement")
                }
            }
            .buttonStyle(.borderless)

            // édition de la liste des événements
            ForEach($school.events.sorted(by: { $0.wrappedValue.date < $1.wrappedValue.date })) { $event in
                EventEditor(event: $event)
            }
            .onDelete { indexSet in
                school.events.remove(atOffsets: indexSet)
            }

        } header: {
            Text("Événements (\(school.nbOfEvents))")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
    }
}

//struct EventList_Previews: PreviewProvider {
//    static var previews: some View {
//        EventList()
//    }
//}
