//
//  AnnotationView.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 17/06/2022.
//

import SwiftUI

struct AnnotationView: View {
    @Binding var isExpanded: Bool
    @Binding var isModified: Bool
    @Binding var annotation: String
    @Environment(\.horizontalSizeClass)
    private var hClass

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            if #available(iOS 16.0, macOS 13.0, *) {
                TextField("Annotation", text: $annotation, axis: .vertical)
                    .lineLimit(5)
                    .font(hClass == .compact ? .callout : .body)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextEditor(text: $annotation)
                    .font(hClass == .compact ? .callout : .body)
                    .multilineTextAlignment(.leading)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
                    .frame(minHeight: 80)
            }
        } label: {
            Text("Annotation")
                .font(.headline)
                .fontWeight(.bold)
        }
        .listRowSeparator(.hidden)
        .onChange(of: annotation) { newValue in
            isModified = true
        }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(isExpanded: .constant(true),
                       isModified: .constant(false),
                       annotation: .constant("Ceci est une annotation"))
    }
}
