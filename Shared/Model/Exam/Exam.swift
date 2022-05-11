//
//  Exam.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 10/05/2022.
//

import Foundation

struct Exam: Identifiable, Codable {
    var id = UUID()
    var sujet   : String = ""
    var maxMark : Int    = 20
    var date    : Date   = Date.now
    var marks   : [Mark] = []
}

extension Exam: CustomStringConvertible {
    var description: String {
        """

        Sujet   : \(sujet)
        Noté sur: \(maxMark)
        Date    : \(date.stringLongDate)
        """
    }
}
