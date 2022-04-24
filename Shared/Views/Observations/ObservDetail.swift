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
                    Text("Notifié")
                }
                .buttonStyle(.plain)
                .padding(.leading)

                Button {
                    observ.isVerified.toggle()
                } label: {
                    Image(systemName: observ.isVerified ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.gray)
                    Text("Vérifié")
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
            NavigationView {
                ObservDetail(observ: .constant(TestEnvir.observStore.items.first!),
                             isEditing  : false,
                             isNew      : false,
                             isModified : .constant(false))
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
            }
            .previewDisplayName("Display Classe")
        }
    }
}
