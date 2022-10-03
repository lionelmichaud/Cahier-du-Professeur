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
    var observ: Observation

    @EnvironmentObject private var eleveStore : EleveStore

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

    var eleve: Eleve? {
        guard let eleveId = observ.eleveId else {
            return nil
        }
        return eleveStore.item(withID: eleveId)
    }

    var body: some View {
        VStack {
            // élève
            if let eleve {
                EleveLabelWithTrombineFlag(eleve      : .constant(eleve),
                                           isModified : .constant(false),
                                           isEditable : false,
                                           font       : .title2,
                                           fontWeight : .regular)
            } else {
                Text("Elève introubale !").foregroundColor(.red)
            }

            // observation
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .sfSymbolStyling()
                        .foregroundColor(observ.color)
                    // date
                    DatePicker("Date", selection: $observ.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                }

                // motif
                MotifEditor(motif: $observ.motif)

                // checkbox isConsignee
                Button {
                    observ.isConsignee.toggle()
                } label: {
                    isConsigneeLabel
                }
                .buttonStyle(.plain)

                // checkbox isVerified
                Button {
                    observ.isVerified.toggle()
                } label: {
                    isVerifiedLabel
                }
                .buttonStyle(.plain)
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
            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!))
            .environmentObject(TestEnvir.schoolStore)
            .environmentObject(TestEnvir.classeStore)
            .environmentObject(TestEnvir.eleveStore)
            .environmentObject(TestEnvir.colleStore)
            .environmentObject(TestEnvir.observStore)
            .previewDevice("iPad mini (6th generation)")
            .previewDisplayName("Observ isNew")

            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!))
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
