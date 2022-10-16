//
//  Mark.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 24/05/2022.
//

import SwiftUI
import HelpersView

struct MarkView: View {
    let eleve         : Eleve
    let maxMark       : Int
    @Binding var type : MarkEnum
    @Binding var mark : Double?

    @Preference(\.nameDisplayOrder)
    private var nameDisplayOrder

    @Environment(\.horizontalSizeClass)
    private var hClass

    var body: some View {
        Group {
            switch type {
                case .note:
                    if hClass == .compact {
                        VStack(alignment: .leading) {
                            CasePicker(pickedCase : $type,
                                       label      : eleve.displayName(nameDisplayOrder))
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
                            AmountEditView(label    : eleve.displayName(nameDisplayOrder),
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
                            if #available(iOS 16.0, macOS 13.0, *) {
                                CasePicker(pickedCase: $type,
                                           label: "")
                                .pickerStyle(.menu)
                                .frame(maxWidth: 120)
                            } else {
                                HStack {
                                    Spacer()
                                    CasePicker(pickedCase: $type,
                                               label: "")
                                    .pickerStyle(.menu)
                                }
                                .frame(maxWidth: 120)
                            }
                        }
                    }

                default:
                    CasePicker(pickedCase: $type,
                               label: eleve.displayName(nameDisplayOrder))
                    .pickerStyle(.menu)
            }
        }
    }
}

struct MarkView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MarkView(eleve   : Eleve.exemple,
                     maxMark : 20,
                     type    : .constant(.nonNote),
                     mark    : .constant(0.0))
        }
        List {
            MarkView(eleve   : Eleve.exemple,
                     maxMark : 20,
                     type    : .constant(.note),
                     mark    : .constant(10.0))
        }
    }
}
