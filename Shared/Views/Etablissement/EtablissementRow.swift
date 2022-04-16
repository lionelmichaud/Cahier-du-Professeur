//
//  EtablissementRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct EtablissementRow: View {
    let etablissement: Etablissement

    var body: some View {
        Label(
            title: {
                Text(etablissement.displayString)
            },
            icon: {
                Image(systemName: etablissement.niveau == .lycee ? "building.2" : "building")
                    .imageScale(.large)
                    .foregroundColor(etablissement.niveau == .lycee ? .mint : .orange)
            }
        )
        .badge(etablissement.nbOfClasses)
    }
}

struct EtablissementRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return EtablissementRow(etablissement: TestEnvir.etabStore.items.first!)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
