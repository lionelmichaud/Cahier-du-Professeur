//
//  Exam.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 10/05/2022.
//

import Foundation

struct Exam: Identifiable, Hashable, Codable {

    // MARK: - Properties

    var id = UUID()
    var sujet   : String = ""
    var maxMark : Int    = 20
    var coef    : Double = 1.0
    var date    : Date   = Date.now
    var marks   : EleveMarkDico = [:]

    // MARK: - Initializers

    internal init(id       : UUID   = UUID(),
                  sujet    : String = "",
                  maxMark  : Int    = 20,
                  coef     : Double = 1.0,
                  date     : Date   = Date.now,
                  elevesId : [UUID] = []) {
        self.id = id
        self.sujet = sujet
        self.maxMark = maxMark
        self.coef = coef
        self.date = date
        elevesId.forEach { id in
            marks[id] = nil
        }
    }
}

extension Exam: CustomStringConvertible {
    var description: String {
        """

        Sujet      : \(sujet)
        Noté sur   : \(maxMark)
        Coefficient: \(coef.formatted(.number.precision(.fractionLength(2))))
        Date       : \(date.stringLongDate)
        """
    }
}
