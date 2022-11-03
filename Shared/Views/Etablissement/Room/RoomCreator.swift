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

    var school: School

    @EnvironmentObject
    private var classStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

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
        Stepper {
            HStack {
                Text(hClass == .regular ? "Nombre de places" : "Nombre de places")
                Spacer()
                Text("\(room.capacity)")
                    .foregroundColor(.secondary)
            }
        } onIncrement: {
            room.incrementCapacity()
        } onDecrement: {
            room.decrementCapacity(dans       : school,
                                   classStore : classStore,
                                   eleveStore : eleveStore)
        }
    }

    private var compactView: some View {
        VStack {
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

    private var largeView: some View {
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
    }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            largeView
            compactView
        }
        // Modal: ajout d'une nouvelle classe
        .sheet(isPresented: $isPlacing) {
            NavigationStack {
                RoomEditor(room: $room, school: school)
            }
            .presentationDetents([.large])
        }
    }
}

struct RoomCreator_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                RoomCreator(room: .constant(Room(name: "TECHNO-2",
                                                 capacity: 12)),
                            school: TestEnvir.schoolStore.items.first!)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")
        }
    }
}
