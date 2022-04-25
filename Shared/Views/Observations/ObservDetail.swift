//
//  ObservDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ObservDetail: View {
    @Binding
    var observ    : Observation
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    var isConsigneeLabel: some View {
        Label(
            title: {
                Text("Notifiée aux parents")
            }, icon: {
                Image(systemName: observ.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(observ.isConsignee ? .green : .gray)
            }
        )
    }

    var isVerifiedLabel: some View {
        Label(
            title: {
                Text("Signature des parents vérifiée")
            }, icon: {
                Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(observ.isVerified ? .green : .gray)
            }
        )
    }

    var body: some View {
        List {
            HStack {
                Image(systemName: "magnifyingglass")
                    .sfSymbolStyling()
                    .foregroundColor(.red)
                // date
                if isNew || isEditing {
                    DatePicker("Date", selection: $observ.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                } else {
                    Text(observ.date.formatted(date: .abbreviated, time: .shortened))
                }
            }

            // motif
            if isNew || isEditing {
                HStack(alignment: .center) {
                    Text("Motif")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    Divider()
                    VStack (alignment: .leading) {
                        CasePicker(pickedCase: $observ.motif.nature,
                                   label: "Motif")
                        .pickerStyle(.menu)
                        if observ.motif.nature == .autre {
                            TextField("description", text: $observ.motif.description.bound)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                        }
                    }
                }
            } else {
                HStack(alignment: .center) {
                    Text("Motif")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    Divider()
                    if observ.motif.nature == .autre {
                        Text(observ.motif.description ?? "Autre motif")
                    } else {
                        VStack (alignment: .leading) {
                            Text(observ.motif.nature.displayString)
                            if let description = observ.motif.description {
                                Text(description)
                            }
                        }
                    }
                }
            }

            // checkbox isConsignee
            if isNew || isEditing {
                Button {
                    observ.isConsignee.toggle()
                } label: {
                    isConsigneeLabel
                }
                .buttonStyle(.plain)
            } else {
                isConsigneeLabel
            }

            // checkbox isVerified
            if isNew || isEditing {
                Button {
                    observ.isVerified.toggle()
                } label: {
                    isVerifiedLabel
                }
                .buttonStyle(.plain)
            } else {
                isVerifiedLabel
            }
        }
#if os(iOS)
        .navigationTitle("Observation")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct ObservDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!),
                         isEditing  : false,
                         isNew      : true,
                         isModified : .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")
            .previewDisplayName("Observ isNew")

            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!),
                         isEditing  : false,
                         isNew      : true,
                         isModified : .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
            .previewDisplayName("Observ isNew")

            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!),
                         isEditing  : false,
                         isNew      : false,
                         isModified : .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
            .previewDisplayName("Observ display")
        }
    }
}
