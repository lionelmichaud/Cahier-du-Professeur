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

    @Environment(\.horizontalSizeClass) private var hClass

    var body: some View {
        Group {
            switch type {
                case .note:
                    if hClass == .compact {
                        VStack(alignment: .leading) {
                            CasePicker(pickedCase: $type,
                                       label: eleveName)
                            .pickerStyle(.menu)
                            HStack {
                                AmountEditView(label    : "Note",
                                               amount   : $mark.bound,
                                               validity : .within(range: 0.0 ... Double(maxMark)),
                                               currency : false)
                                Stepper(
                                    "",
                                    onIncrement: {
                                        mark = ((mark ?? 0.0) + 0.5).clamp(low: 0.0, high: Double(maxMark))
                                    },
                                    onDecrement: {
                                        mark = ((mark ?? 0.0) - 0.5).clamp(low: 0.0, high: Double(maxMark))
                                    })
                            }
                        }
                    } else {
                        HStack {
                            AmountEditView(label    : eleveName,
                                           amount   : $mark.bound,
                                           validity : .within(range: 0.0 ... Double(maxMark)),
                                           currency : false)
                            Stepper(
                                "",
                                onIncrement: {
                                    mark = ((mark ?? 0.0) + 0.5).clamp(low: 0.0, high: Double(maxMark))
                                },
                                onDecrement: {
                                    mark = ((mark ?? 0.0) - 0.5).clamp(low: 0.0, high: Double(maxMark))
                                })
                            .frame(maxWidth: 100)
                            CasePicker(pickedCase: $type,
                                       label: "")
                            .pickerStyle(.menu)
                            .frame(maxWidth: 120)
                        }
                    }

                default:
                    CasePicker(pickedCase: $type,
                               label: eleveName)
                    .pickerStyle(.menu)
            }
        }
    }
}

struct MarkView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MarkView(eleveName : "Lionel MICHAUD",
                     maxMark   : 20,
                     type      : .constant(.nonNote),
                     mark      : .constant(0.0))
        }
        List {
            MarkView(eleveName : "Lionel MICHAUD",
                     maxMark   : 20,
                     type      : .constant(.note),
                     mark      : .constant(10.0))
        }
    }
}
