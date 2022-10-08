//
//  AppreciationView.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 17/06/2022.
//

import SwiftUI

struct AppreciationView: View {
    @Binding var isExpanded: Bool
    @Binding var appreciation: String
    @Environment(\.horizontalSizeClass)
    private var hClass

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            if #available(iOS 16.0, macOS 13.0, *) {
                TextField("Appréciation", text: $appreciation, axis: .vertical)
                    .lineLimit(5)
                    .font(hClass == .compact ? .callout : .body)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextEditor(text: $appreciation)
                    .font(hClass == .compact ? .callout : .body)
                    .multilineTextAlignment(.leading)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                    .frame(minHeight: 80)
            }
        } label: {
            Text("Appréciation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .listRowSeparator(.hidden)
    }
}

struct AppreciationView_Previews: PreviewProvider {
    static var previews: some View {
        AppreciationView(isExpanded: .constant(true),
                         appreciation: .constant("Ceci est une appréciation"))
    }
}
