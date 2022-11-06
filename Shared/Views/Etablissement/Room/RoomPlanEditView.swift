//
//  RoomPlan.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/10/2022.
//

import SwiftUI
import os
import HelpersView

private let customLog = Logger(subsystem : "com.michaud.lionel.Cahier-du-Professeur",
                               category  : "RoomPlanEditView")

public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

struct RoomPlanEditView: View {
    @Binding
    var room: Room

    var school: School

    @EnvironmentObject
    private var classStore  : ClasseStore

    @EnvironmentObject
    private var eleveStore : EleveStore

    @State
    private var showLongPressMenu = false

    @State
    private var isImportingPngFile = false

    @State
    private var alertItem: AlertItem?

    // MARK: - Computd Properties

    private var imageSize: CGSize? {
        room.imageSize
    }

    var body: some View {
        if let imageSize {
            ZStack(alignment: .topLeading) {
                GeometryReader { viewGeometry in
                    /// Image du plan de la salle
                    LoadableImage(imageUrl         : room.planURL,
                                  placeholderImage : .constant(Image(systemName : "questionmark.app.dashed")))

                    /// Symboles des places des élèves dans la salle
                    if room.nbSeatPositionned > 0 {
                        ForEach(0 ... (room.nbSeatPositionned - 1), id:\.self) { idxSeat in
                            DraggableSeatLabel(
                                seatLocInRoom    : $room[seatIndex: idxSeat].locInRoom,
                                viewGeometrySize : viewGeometry.size,
                                imageSize        : imageSize,
                                delete: {
                                    withAnimation {
                                        room.removeSeatFromPlan(seatIndex  : idxSeat,
                                                                dans       : school,
                                                                classStore : classStore,
                                                                eleveStore : eleveStore)
                                    }
                                }
                            )
                        }
                    }
                }
            }
        } else {
            VStack {
                Text("Pas de plan disponible pour la salle \"\(room.name)\"")
                    .padding()
                
                /// Télécharger un plan au format PNG
                Button {
                    isImportingPngFile.toggle()
                } label: {
                    Label("Importer un plan au format '\(room.planURL.pathExtension)' et nommé '\(room.fileName)'",
                          systemImage: "square.and.arrow.down")
                }
                /// Importer des fichiers PDF
                .fileImporter(isPresented             : $isImportingPngFile,
                              allowedContentTypes     : [.png],
                              allowsMultipleSelection : false) { result in
                    importUserSelectedFiles(result: result)
                    // TODO: - renommer le fichier si le nom du fichier imprté n'est pas le bon
                }
                .alert(item: $alertItem, content: newAlert)

            }
        }
    }

    // MARK: - Methods

    /// Copier les fichiers  sélectionnés dans le dossier Document de l'application.
    /// Ajouter un document à l'établissement pour chaque fichier importé.
    /// - Parameter result: résultat de la sélection des fichiers issue de fileImporter.
    private func importUserSelectedFiles(result: Result<[URL], Error>) {
        switch result {
            case .failure(let error):
                self.alertItem = AlertItem(title         : Text("Échec"),
                                           message       : Text("L'importation du fichier a échouée"),
                                           dismissButton : .default(Text("OK")))
                customLog.log(level: .fault,
                              "Error selecting file: \(error.localizedDescription)")

            case .success(let filesUrl):
                if let theFileURL = filesUrl.first {
                    // Si le fichier ne porte le bon nom, arrêter l'importation
                    guard theFileURL.pathComponents.last == room.fileName else {
                        self.alertItem = AlertItem(title         : Text("Échec"),
                                                   message       : Text("Le nom du fichier importé ne correspond pas au nom de la salle de classe."),
                                                   dismissButton : .default(Text("OK")))
                        return
                    }

                    do {
                        try ImportExportManager
                            .importURLsToDocumentsFolder(filesUrl             : [theFileURL],
                                                         importIfAlreadyExist : true)

                    } catch {
                        self.alertItem = AlertItem(title         : Text("Échec"),
                                                   message       : Text("L'importation du fichier a échouée"),
                                                   dismissButton : .default(Text("OK")))
                    }
                }
        }
    }
}

struct RoomPlan_Previews: PreviewProvider {
    static var room: Room = {
        var r = Room(name: "TECHNO-2", capacity: 12)
        r.addSeatToPlan(Seat(x: 0.0, y: 0.0))
        r.addSeatToPlan(Seat(x: 0.25, y: 0.25))
        r.addSeatToPlan(Seat(x: 0.5, y: 0.5))
        r.addSeatToPlan(Seat(x: 0.75, y: 0.75))
        r.addSeatToPlan(Seat(x: 0.98, y: 0.98))
        return r
    }()
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                RoomPlanEditView(room  : .constant(room),
                                 school: TestEnvir.schoolStore.items.first!)
                .environmentObject(NavigationModel(selectedClasseId: TestEnvir.classeStore.items.first!.id))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                RoomPlanEditView(room  : .constant(room),
                                 school: TestEnvir.schoolStore.items.first!)
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
