//
//  RoomEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/10/2022.
//

import SwiftUI

struct RoomEditor: View {
    @Binding
    var room: Room

    @Environment(\.horizontalSizeClass)
    var hClass

    var name: some View {
        HStack {
            Image(systemName: "latch.2.case")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)
            TextField("Nom de la salle", text: $room.name)
                .textFieldStyle(.roundedBorder)
        }
    }

    var quantity: some View {
        Stepper(value : $room.maxNumberOfEleve,
                in    : 1 ... 100,
                step  : 1) {
            HStack {
                Text(hClass == .regular ? "Nombre maximumd'élèves" : "Elèves maxi")
                Spacer()
                Text("\(room.maxNumberOfEleve)")
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        if hClass == .regular {
            HStack {
                name
                quantity
                    .frame(maxWidth: 400)
            }
        } else {
            GroupBox {
                name
                quantity
            }
        }
    }
}

struct RoomEditor_Previews: PreviewProvider {
    static var previews: some View {
        RoomEditor(room: .constant(Room(name: "TECHNO-2",
                                        maxNumberOfEleve: 12)))
    }
}
