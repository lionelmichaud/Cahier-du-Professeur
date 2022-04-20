//
//  SchoolRow.swift
//  Cahier du Professeur (iOS)
//
//  Created by Lionel MICHAUD on 15/04/2022.
//

import SwiftUI

struct SchoolRow: View {
    let school: School

    var body: some View {
        Label(
            title: {
                Text(school.displayString)
            },
            icon: {
                Image(systemName: school.niveau == .lycee ? "building.2" : "building")
                    .imageScale(.large)
                    .foregroundColor(school.niveau == .lycee ? .mint : .orange)
            }
        )
        .badge(school.nbOfClasses)
    }
}

struct SchoolRow_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return SchoolRow(school: TestEnvir.etabStore.items.first!)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
