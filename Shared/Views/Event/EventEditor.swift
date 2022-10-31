//
//  EventEditor.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 24/10/2022.
//

import SwiftUI

struct EventEditor: View {
    @Binding
    var event: Event

    @Environment(\.horizontalSizeClass)
    var hClass

    var date: some View {
        HStack {
            Image(systemName: "calendar")
                .sfSymbolStyling()
                .foregroundColor(.accentColor)

            DatePicker("Date",
                       selection           : $event.date,
                       displayedComponents : [.date])
            .labelsHidden()
            .environment(\.locale, Locale.init(identifier: "fr_FR"))
            Spacer()
        }
    }

    var body: some View {
        if hClass == .regular {
            HStack {
                date
                    .frame(maxWidth: 150)
                TextField("Événement", text: $event.name)
                    .lineLimit(2...3)
                    .font(hClass == .compact ? .callout : .body)
                    .textFieldStyle(.roundedBorder)
            }
        } else {
            GroupBox {
                date
                TextField("Événement", text: $event.name)
                    .lineLimit(2...3)
                    .font(hClass == .compact ? .callout : .body)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct EventEditor_Previews: PreviewProvider {
    static var previews: some View {
        EventEditor(event: .constant(Event.exemple))
    }
}
