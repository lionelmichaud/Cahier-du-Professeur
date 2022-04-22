//
//  ClasseBrowserView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 21/04/2022.
//

import SwiftUI

struct ClasseBrowserView: View {
    @EnvironmentObject var schoolStore : SchoolStore
    @EnvironmentObject var classeStore : ClasseStore
    @EnvironmentObject var eleveStore  : EleveStore

    var body: some View {
        List {
            ForEach(schoolStore.items.sorted(by: { $0.niveau.rawValue < $1.niveau.rawValue })) { school in
                if school.nbOfClasses != 0 {
                    Section {
                        ForEach(classeStore.classes(dans: school)) { $classe in
                            NavigationLink {
                                EmptyView()
                            } label: {
                                ClassRow(classe: classe)
                            }
                        }
                    } header: {
                        Text(school.displayString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationTitle("Classes")
    }
}

struct ClasseBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        ClasseBrowserView()
    }
}
