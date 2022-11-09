//
//  RoomEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 22/10/2022.
//

import SwiftUI
import os

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "RoomElevePlacement")

struct RoomElevePlacement: View {
    @Binding
    var classe: Classe

    @EnvironmentObject
    private var schoolStore : SchoolStore

    @EnvironmentObject
    private var eleveStore : EleveStore

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

    private var imageSize: CGSize? {
        room?.imageSize
    }

    private var associateClasseToRoomMenu: some View {
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
                if let roomPlanURL = room?.planURL,
                   let imageSize {
                    ZStack(alignment: .topLeading) {
                        GeometryReader { viewGeometry in
                            LoadableImage(imageUrl: roomPlanURL,
                                          placeholderImage: .constant(Image(systemName: "questionmark.app.dashed")))

                            // Symboles des places des élèves dans la salle
                            if room!.nbSeatPositionned > 0 {
                                ForEach(0 ... (room!.nbSeatPositionned - 1), id:\.self) { idxSeat in
                                    EditableSeatLabel(
                                        classe           : classe,
                                        seat             : room![seatIndex: idxSeat],
                                        viewGeometrySize : viewGeometry.size,
                                        imageSize        : imageSize)
                                }
                            }
                        }
                    }
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
                        Label("Dissocier de cette salle", systemImage: "minus.circle.fill")
                    }
                    .confirmationDialog("Dissocier la classe de cette salle?",
                                        isPresented: $isShowingDissociateDialog,
                                        titleVisibility: .visible) {
                        Button("Dissocier de cette salle de classe", role: .destructive) {
                            withAnimation {
                                if let room {
                                    // Retirer tous les éléves de la `classe` des sièges de la salle de classe.
                                    room.removeAllSeatedEleve(dans: classe,
                                                              eleveStore: eleveStore)
                                } else {
                                    customLog.log(level: .fault,
                                                  "Dissocier: Le plan associé à la salle de classe n'a pas été trouvé")
                                }
                                classe.roomId = nil
                            }
                        }
                    } message: {
                        Text("La classe de \(classe.displayString) ne sera plus associée à la salle de classe \(room!.name).\n") +
                        Text("Cette action ne peut pas être annulée.")
                    }
                } else if school != nil {
                    /// associer la classe à une salle de classe
                    associateClasseToRoomMenu
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
                RoomElevePlacement(classe: .constant(TestEnvir.classeStore.items.first!))
                    .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomElevePlacement(classe: .constant(TestEnvir.classeStore.items.first!))
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
