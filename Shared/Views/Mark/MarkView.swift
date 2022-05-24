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
    @Binding var type : MarkEnum
    @Binding var mark : Double?

    var body: some View {
        VStack(alignment: .leading) {
            switch type {
                case .note:
                    AmountEditView(label    : eleveName,
                                   amount   : $mark.bound,
                                   validity : .within(range: 0.0 ... Double(maxMark)),
                                   currency : false)
                    HStack {
                        CasePicker(pickedCase: $type,
                                   label: "")
                        .pickerStyle(.menu)
                        Stepper(
                            "",
                            onIncrement: {
                                mark = ((mark ?? 0.0) + 0.5).clamp(low: 0.0, high: Double(maxMark))
                            },
                            onDecrement: {
                                mark = ((mark ?? 0.0) - 0.5).clamp(low: 0.0, high: Double(maxMark))
                            })
                    }
                default:
                    HStack {
                        VStack(alignment: .leading) {
                            Text(eleveName)
                            CasePicker(pickedCase: $type,
                                       label: "")
                            .pickerStyle(.menu)
                        }
                        Spacer()

                    }
            }
        }
    }
}

struct MarkView_Previews: PreviewProvider {
    static var previews: some View {
        MarkView(eleveName : "Nom",
                 maxMark   : 20,
                 type      : .constant(.nonNote),
                 mark      : .constant(0.0))
        MarkView(eleveName : "Nom",
                 maxMark   : 20,
                 type      : .constant(.note),
                 mark      : .constant(10.0))
    }
}
