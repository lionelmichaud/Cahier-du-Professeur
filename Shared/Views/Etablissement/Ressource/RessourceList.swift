//
//  RessourceList.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 03/11/2022.
//

import SwiftUI

/// Vue de la liste des ressources de l'établissement
struct RessourceList: View {
    @Binding
    var school: School

    var body: some View {
        Section {
            // ajouter une évaluation
            Button {
                withAnimation {
                    school.ressources.insert(Ressource(), at: 0)
                }
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ajouter une ressource")
                }
            }
            .buttonStyle(.borderless)

            // édition de la liste des examen
            ForEach($school.ressources) { $res in
                RessourceEditor(ressource: $res)
            }
            .onDelete { indexSet in
                school.ressources.remove(atOffsets: indexSet)
            }
            .onMove { fromOffsets, toOffset in
                school.ressources.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }

        } header: {
            Text("Ressources (\(school.nbOfRessources))")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontWeight(.bold)
        }
    }
}

//struct RessourceList_Previews: PreviewProvider {
//    static var previews: some View {
//        RessourceList()
//    }
//}
