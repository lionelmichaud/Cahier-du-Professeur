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
    var eleve     : Eleve
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
        VStack {
            // élève
            EleveLabelWithTrombineFlag(eleve     : $eleve,
                                       isModified: $isModified,
                                       font      : .title2,
                                       fontWeight: .regular)
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .sfSymbolStyling()
                        .foregroundColor(observ.color)
                    // date
                    if isNew || isEditing {
                        DatePicker("Date", selection: $observ.date)
                            .labelsHidden()
                            .listRowSeparator(.hidden)
                            .environment(\.locale, Locale.init(identifier: "fr_FR"))
                    } else {
                        Text("Le " + observ.date.stringLongDateTime)
                    }
                }

                // motif
                if isNew || isEditing {
                    MotifEditor(motif: $observ.motif)
                } else {
                    MotifView(motif: observ.motif)
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
        }
        #if os(iOS)
        .navigationTitle("Observation")
        //.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct ObservDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ObservDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                         observ     : .constant(TestEnvir.observStore.items.first!),
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

            ObservDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                         observ     : .constant(TestEnvir.observStore.items.first!),
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

            ObservDetail(eleve      : .constant(TestEnvir.eleveStore.items.first!),
                         observ     : .constant(TestEnvir.observStore.items.first!),
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
