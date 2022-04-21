//
//  ClassDetail.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 20/04/2022.
//

import SwiftUI
import HelpersView

struct ClassDetail: View {
    @Binding var classe: Classe
    let isEditing : Bool
    var isNew     : Bool

    var body: some View {
        List {
            // nom
            if isNew || isEditing {
                HStack {
                    Image(systemName: "person.3.fill")
                        .imageScale(.large)
                        .foregroundColor(classe.niveau.color)
                    HStack {
                        Text("Niveau")
                        CasePicker(pickedCase: $classe.niveau, label: "Niveau")
                            .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                    Text("Numéro de classe")
                    Picker("Numéro de classe", selection: $classe.numero) {
                        ForEach(1...8, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.menu)
                }
            } else {
                HStack {
                    Image(systemName: "person.3.fill")
                        .imageScale(.large)
                        .foregroundColor(classe.niveau.color)
                    Text(classe.displayString)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

struct ClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        TestEnvir.createFakes()
        return NavigationView {
            EmptyView()
            ClassDetail(classe    : .constant(TestEnvir.classeStore.items.first!),
                        isEditing : false,
                        isNew     : true)
                .environmentObject(TestEnvir.classeStore)
                .environmentObject(TestEnvir.eleveStore)
                .environmentObject(TestEnvir.colleStore)
                .environmentObject(TestEnvir.observStore)
        }
    }
}
