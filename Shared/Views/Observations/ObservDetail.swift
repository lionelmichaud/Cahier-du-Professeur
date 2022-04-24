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
    var observ     : Observation
    let isEditing : Bool
    var isNew     : Bool
    @Binding
    var isModified: Bool

    var body: some View {
        List {
            HStack {
                Image(systemName: "magnifyingglass")
                    .sfSymbolStyling()
                    .foregroundColor(.red)
                if isNew || isEditing {
                    DatePicker("Date", selection: $observ.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                } else {
                    Text(observ.date.formatted(date: .abbreviated, time: .shortened))
                }
            }

            if isNew || isEditing {
                Button {
                    observ.isConsignee.toggle()
                } label: {
                    Image(systemName: observ.isConsignee ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                    Text("Notifiée aux parents")
                }
                .buttonStyle(.plain)
                .padding(.leading)

                Button {
                    observ.isVerified.toggle()
                } label: {
                    Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                    Text("Signature des parents vérifiée")
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
        }
    }
}
