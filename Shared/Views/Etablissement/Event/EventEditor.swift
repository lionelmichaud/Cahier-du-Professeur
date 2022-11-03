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
        let layout = hClass == .regular ?
        AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

        layout {
            if hClass == .regular {
                date
                    .frame(maxWidth: 175)
            } else {
                date
            }
            TextField("Événement", text: $event.name)
                .lineLimit(2...3)
                .font(hClass == .compact ? .callout : .body)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct EventEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                EventEditor(event: .constant(Event.exemple))
                EventEditor(event: .constant(Event.exemple))
            }
            .previewDevice("iPad mini (6th generation)")

            List {
                EventEditor(event: .constant(Event.exemple))
                EventEditor(event: .constant(Event.exemple))
            }
            .previewDevice("iPhone 13")
        }
    }
}
