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
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct ObservDetail2: View {
    @EnvironmentObject private var navigationModel : NavigationModel
    @EnvironmentObject private var observStore     : ObservationStore
    @EnvironmentObject private var eleveStore      : EleveStore

    @State
    private var isConsignee: Bool = false

    @State
    private var isVerified: Bool = false

    private var observ: Observation {
        observStore.item(withID: navigationModel.selectedObservId!)!
    }

    private var isConsigneeLabel: some View {
        Label(
            title: {
                Text("Notifiée aux parents")
            }, icon: {
                Image(systemName: isConsignee ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isConsignee ? .green : .gray)
            }
        )
    }

    private var isVerifiedLabel: some View {
        Label(
            title: {
                Text("Signature des parents vérifiée")
            }, icon: {
                Image(systemName: isVerified ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isVerified ? .green : .gray)
            }
        )
    }

    private var eleve: Eleve? {
        guard let eleveId = observ.eleveId else {
            return nil
        }
        return eleveStore.item(withID: eleveId)
    }

    private var selectedItemExists: Bool {
        guard let selectedObservId = navigationModel.selectedObservId else {
            return false
        }
        return observStore.contains(selectedObservId)
    }

    var body: some View {
        if selectedItemExists {
            VStack {
                /// élève
                if let eleve {
                    EleveLabelWithTrombineFlag(eleve      : .constant(eleve),
                                               isModified : .constant(false),
                                               isEditable : false,
                                               font       : .title2,
                                               fontWeight : .regular)
                } else {
                    Text("Elève introubale !").foregroundColor(.red)
                }

                /// observation
                List {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .sfSymbolStyling()
                            .foregroundColor(observ.color)
                        /// date
                        //                    DatePicker("Date", selection: $observ.date)
                        //                        .labelsHidden()
                        //                        .listRowSeparator(.hidden)
                        //                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                    }

                    /// motif
                    //                MotifEditor(motif: $observ.motif)

                    /// checkbox isConsignee
                    Button {
                        isConsignee.toggle()
                    } label: {
                        isConsigneeLabel
                    }
                    .buttonStyle(.plain)

                    /// checkbox isVerified
                    Button {
                        isVerified.toggle()
                    } label: {
                        isVerifiedLabel
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear {
                isConsignee = observ.isConsignee
                isVerified  = observ.isVerified
            }
            #if os(iOS)
            .navigationTitle("Observation")
            .navigationBarTitleDisplayMode(.inline)
            #endif
        } else {
            VStack(alignment: .center) {
                Text("Aucune observation sélectionnée.")
                Text("Sélectionner une observation.")
            }
            .foregroundStyle(.secondary)
            .font(.title)
        }
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

            ObservDetail(observ: .constant(TestEnvir.observStore.items.first!))
                .environmentObject(TestEnvir.schoolStore)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
                .previewDevice("iPhone 13")
        }
    }
}
