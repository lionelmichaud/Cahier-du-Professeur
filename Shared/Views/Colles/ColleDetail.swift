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

    var body: some View {
        List {
            HStack {
                Image(systemName: "lock")
                    .sfSymbolStyling()
                    .foregroundColor(.red)
                if isNew || isEditing {
                    DatePicker("Date", selection: $colle.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                } else {
                    Text(colle.date.formatted(date: .abbreviated, time: .shortened))
                }
            }

            if isNew || isEditing {
                Button {
                    colle.isConsignee.toggle()
                } label: {
                    Image(systemName: colle.isConsignee ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                    Text("Notifiée à la vie scolaire")
                }
                .buttonStyle(.plain)
                .padding(.leading)

                Button {
                    colle.isVerified.toggle()
                } label: {
                    Image(systemName: colle.isVerified ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                    Text("Exécutée par l'élève")
                }
                .buttonStyle(.plain)
                .padding(.leading)
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
