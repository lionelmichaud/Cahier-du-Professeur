//
//  Classe.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 14/04/2022.
//

import Foundation

struct Classe: Identifiable, Codable, Ordered, Hashable {

    // MARK: - Type Properties

    static let exemple = Classe(niveau : .n6ieme,
                                numero : 1,
                                heures : 1.5)
    // MARK: - Type Methods

    static func < (lhs: Classe, rhs: Classe) -> Bool {
        if lhs.niveau.rawValue != rhs.niveau.rawValue {
            return lhs.niveau.rawValue > rhs.niveau.rawValue
        } else {
            return lhs.numero < rhs.numero
        }
    }

    // MARK: - Properties

    var id = UUID()
    var schoolId     : UUID?
    var roomId       : UUID?
    var niveau       : NiveauClasse = .n6ieme
    var numero       : Int    = 1
    var heures       : Double = 0
    var segpa        : Bool   = false
    var isFlagged    : Bool   = false
    var appreciation : String = ""
    var annotation   : String = ""
    var elevesID     : [UUID] = []
    var exams        : [Exam] = []

    // MARK: - Computed Properties

    var hasAssociatedRoom: Bool {
        roomId != nil
    }

    var nbOfEleves: Int {
        elevesID.count
    }

    var nbOfExams: Int {
        exams.count
    }

    var elevesListLabel: String {
        if nbOfEleves == 0 {
            return "Aucun élève"
        } else if nbOfEleves == 1 {
            return "Liste de 1 élève"
        } else {
            return "Liste des \(nbOfEleves) élèves"
        }
    }

    var examsListLabel: String {
        if nbOfExams == 0 {
            return "Aucune Évaluation"
        } else if nbOfExams == 1 {
            return "1 Évaluation"
        } else {
            return "\(nbOfExams) Évaluations"
        }
    }

    var displayString: String {
        "\(niveau.displayString)\(numero)\(segpa ? "S" : "")"
    }

    // MARK: - Initializers

    init(schoolId : UUID?  = nil,
         niveau   : NiveauClasse,
         numero   : Int,
         segpa    : Bool = false,
         heures   : Double = 0) {
        self.schoolId = schoolId
        self.niveau   = niveau
        self.numero   = numero
        self.segpa    = segpa
        self.heures   = heures
    }

    // MARK: - Methods

    func contains(eleveId: UUID) -> Bool {
        self.elevesID.contains(eleveId)
    }

    func isSameAs(_ classe: Classe) -> Bool {
        self.niveau == classe.niveau &&
        self.numero == classe.numero &&
        self.schoolId == classe.schoolId
    }
    
    mutating func addEleve(withID eleveID: UUID) {
        elevesID.insert(eleveID, at: 0)
    }

    mutating func removeEleve(withID eleveID: UUID) {
        elevesID.removeAll(where: { $0 == eleveID })
    }

    mutating func removeEleve(at index : Int) {
        elevesID.remove(at: index)
    }

    mutating func moveEleve(from indexes: IndexSet, to destination: Int) {
        elevesID.move(fromOffsets: indexes, toOffset: destination)
    }
}

extension Classe: CustomStringConvertible {
    var description: String {
        """
        
        CLASSE: \(displayString)
           ID      : \(id)
           Niveau  : \(niveau.displayString)
           Numéro  : \(numero)
           SEGPA   : \(segpa.frenchString)
           Heures  : \(heures)
           Flagged : \(isFlagged.frenchString)
           Appréciation: \(appreciation)
           Annotation  : \(annotation)
           SchoolID: \(String(describing: schoolId))
           RoomID  : \(String(describing: roomId))
           Eleves  : \(String(describing: elevesID).withPrefixedSplittedLines("     "))
           Examens : \(String(describing: exams).withPrefixedSplittedLines("     "))
        """
    }
}
