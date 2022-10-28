//
//  RoomPlacement.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI

struct RoomEditor: View {
    @Binding
    var room: Room

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if room.planURL != nil {
            RoomPlanEditView(room: $room)
            .navigationTitle("Places non positionnées: \(room.nbPlacesUndefined)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                /// positionner une nouvelle place au centre du plan de la salle de classe
                Button("Positionner nouvelle place") {
                    withAnimation {
                        room.places.append(CGPoint(x: 0.5, y: 0.5))
                    }
                }
                /// supprimer tous les positionnements de places dans la salle de classe
                Button(role: .destructive) {
                    withAnimation {
                        room.places = []
                    }
                } label: {
                    Label("Tout effacer", systemImage: "trash.fill")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        } else {
            Text("Plan de salle introuvable")
                .foregroundStyle(.secondary)
                .font(.title)
        }
    }
}

struct RoomPlacement_Previews: PreviewProvider {
    static var room: Room = {
        var r = Room(name: "TECHNO-2", capacity: 12)
        r.places.append(CGPoint(x: 0.0, y: 0.0))
        r.places.append(CGPoint(x: 0.25, y: 0.25))
        r.places.append(CGPoint(x: 0.5, y: 0.5))
        r.places.append(CGPoint(x: 0.75, y: 0.75))
        r.places.append(CGPoint(x: 0.98, y: 0.98))
        return r
    }()
    static var previews: some View {
        Group {
            NavigationStack {
                RoomEditor(room: .constant(room))
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomEditor(room: .constant(Room(name: "TECHNO-2",
                                                   capacity: 12)))
            }
            .previewDevice("iPhone 13")
        }
    }
}
