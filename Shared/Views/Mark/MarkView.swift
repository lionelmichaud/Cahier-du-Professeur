//
//  Mark.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 24/05/2022.
//

import SwiftUI
import HelpersView

struct MarkView: View {
    let eleveName     : String
    let maxMark       : Int
    @Binding var mark : Double?

    var body: some View {
        VStack {
            AmountEditView(label    : eleveName,
                           amount   : $mark.bound,
                           validity : .within(range: 0.0 ... Double(maxMark)),
                           currency : false)
            if mark != nil {
            Stepper(
                "",
                onIncrement: {
                    mark = (mark! + 0.5).clamp(low: 0.0, high: Double(maxMark))
                },
                onDecrement: {
                    mark = (mark! - 0.5).clamp(low: 0.0, high: Double(maxMark))
                })
            }
        }
    }
}

struct MarkView_Previews: PreviewProvider {
    static var previews: some View {
        MarkView(eleveName : "Nom",
                 maxMark   : 20,
                 mark      : .constant(0.0))
    }
}
