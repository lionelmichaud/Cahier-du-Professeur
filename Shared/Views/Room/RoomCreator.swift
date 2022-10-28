//
//  RoomEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/10/2022.
//

import SwiftUI

struct RoomCreator: View {
    @Binding
    var room: Room

    @Environment(\.horizontalSizeClass)
    var hClass

    @State
    private var isPlacing = false

    var name: some View {
        HStack {
            Image(systemName: "chair")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)
            TextField("Nom de la salle", text: $room.name)
                .textFieldStyle(.roundedBorder)
        }
    }

    var nbPlaces: some View {
        Stepper(value : $room.capacity,
                in    : 1 ... 100,
                step  : 1) {
            HStack {
                Text(hClass == .regular ? "Nombre de places" : "Nombre de places")
                Spacer()
                Text("\(room.capacity)")
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        Group {
            if hClass == .regular {
                HStack {
                    name
                        .padding(.trailing)
                    nbPlaces
                        .frame(maxWidth: 275)
                        .padding(.trailing)
                    Button("Plan") {
                        isPlacing.toggle()
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                GroupBox {
                    HStack {
                        name
                        Button("Plan") {
                            isPlacing.toggle()
                        }
                        .buttonStyle(.bordered)
                    }
                    nbPlaces
                }
            }
        }
        // Modal: ajout d'une nouvelle classe
        .sheet(isPresented: $isPlacing) {
            NavigationStack {
                RoomEditor(room: $room)
            }
            .presentationDetents([.medium])
        }
    }
}

struct RoomCreator_Previews: PreviewProvider {
    static var previews: some View {
        RoomCreator(room: .constant(Room(name: "TECHNO-2",
                                         capacity: 12)))
    }
}
