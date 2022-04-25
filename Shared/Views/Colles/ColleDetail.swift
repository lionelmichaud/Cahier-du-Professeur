//
//  ColleDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/04/2022.
//

import SwiftUI
import HelpersView

struct ColleDetail: View {
    @Binding
    var colle     : Colle
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    var isConsigneeLabel: some View {
        Label(
            title: {
                Text("Notifiée à la vie scolaire")
            }, icon: {
                Image(systemName: colle.isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(colle.isConsignee ? .green : .gray)
            }
        )
    }

    var isVerifiedLabel: some View {
        Label(
            title: {
                Text("Exécutée par l'élève")
            }, icon: {
                Image(systemName: colle.isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(colle.isVerified ? .green : .gray)
            }
        )
   }

    var body: some View {
        List {
            HStack {
                Image(systemName: "lock")
                    .sfSymbolStyling()
                    .foregroundColor(.red)
                // date
                if isNew || isEditing {
                    DatePicker("Date", selection: $colle.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                } else {
                    Text(colle.date.formatted(date: .abbreviated, time: .shortened))
                }
            }

            // Durée
            if isNew || isEditing {
                HStack {
                    Stepper("Durée",
                            value : $colle.duree,
                            in    : 1 ... 4,
                            step  : 1)
                    .padding(.horizontal)
                    Text("\(colle.duree) heures")
                }
                .frame(width: 280)
            } else {
                Text("Durée: \(colle.duree) heures")
            }

            // checkbox isConsignee
            if isNew || isEditing {
                Button {
                    colle.isConsignee.toggle()
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
                    colle.isVerified.toggle()
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

struct ColleDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            ColleDetail(colle: .constant(TestEnvir.colleStore.items.first!),
                        isEditing  : false,
                        isNew      : true,
                        isModified : .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")
            .previewDisplayName("Colle isNew")

            ColleDetail(colle: .constant(TestEnvir.colleStore.items.first!),
                        isEditing  : false,
                        isNew      : true,
                        isModified : .constant(false))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPhone Xs")
            .previewDisplayName("Colle isNew")
        }
    }
}