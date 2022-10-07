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
    var colle: Colle

    @EnvironmentObject private var eleveStore : EleveStore

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

    var eleve: Eleve? {
        guard let eleveId = colle.eleveId else {
            return nil
        }
        return eleveStore.item(withID: eleveId)
    }

    var body: some View {
        VStack {
            // élève
            if let eleve {
                EleveLabelWithTrombineFlag(eleve      : .constant(eleve),
                                           isEditable : false,
                                           font       : .title2,
                                           fontWeight : .regular)
                .padding(.top)
            }

            // colles
            List {
                HStack {
                    Image(systemName: "lock")
                        .sfSymbolStyling()
                        .foregroundColor(colle.color)
                    // date
                    DatePicker("Date", selection: $colle.date)
                        .labelsHidden()
                        .listRowSeparator(.hidden)
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                }

                // motif
                MotifEditor(motif: $colle.motif)

                // Durée
                HStack {
                    Stepper("Durée",
                            value : $colle.duree,
                            in    : 1 ... 4,
                            step  : 1)
                    Text("\(colle.duree) heures")
                }
                .frame(width: 225)

                // checkbox isConsignee
                Button {
                    colle.isConsignee.toggle()
                } label: {
                    isConsigneeLabel
                }
                .buttonStyle(.plain)

                // checkbox isVerified
                Button {
                    colle.isVerified.toggle()
                } label: {
                    isVerifiedLabel
                }
                .buttonStyle(.plain)
            }
        }
        #if os(iOS)
        .navigationTitle("Colle")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct ColleDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return Group {
            NavigationStack {
                ColleDetail(colle: .constant(TestEnvir.colleStore.items.first!))
                    .environmentObject(NavigationModel())
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPad mini (6th generation)")

            NavigationStack {
                ColleDetail(colle: .constant(TestEnvir.colleStore.items.first!))
                    .environmentObject(NavigationModel(selectedColleId: TestEnvir.eleveStore.items.first!.id))
                    .environmentObject(TestEnvir.schoolStore)
                    .environmentObject(TestEnvir.classeStore)
                    .environmentObject(TestEnvir.eleveStore)
                    .environmentObject(TestEnvir.colleStore)
                    .environmentObject(TestEnvir.observStore)
            }
            .previewDevice("iPhone 13")
        }
    }
}
