//
//  SchoolRessourceRow.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 19/06/2022.
//

import SwiftUI
import HelpersView

struct SchoolRessourceRow: View {
    let ressource: Ressource

    var body: some View {
        HStack {
            //Label(ressource.name, systemImage: "doc.plaintext")
            Label(
                title: {
                    Text(ressource.name)
                        .fontWeight(.semibold)
                },
                icon: {
                    Image(systemName: "latch.2.case")
                        .sfSymbolStyling()
                        .foregroundColor(.accentColor)
                })
            Spacer()
            Text("Quantité disponible: \(ressource.maxNumber)")
                .fontWeight(.semibold)
            //                .font(.caption)
            //                .foregroundStyle(.secondary)
        }
        //.fontWeight(.semibold)
    }
}

struct SchoolRessourceRow_Previews: PreviewProvider {
    static var previews: some View {
        SchoolRessourceRow(ressource: Ressource(name: "Kit robot"))
    }
}
