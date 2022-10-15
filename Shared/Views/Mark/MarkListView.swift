//
//  MarkListView.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 15/10/2022.
//

import SwiftUI
import HelpersView

/// Liste des notes éditables de chaque élève de la classe
struct MarkListView : View {
    @Binding
    var classe : Classe

    @Binding
    var exam: Exam

    var searchString: String

    @EnvironmentObject
    private var eleveStore: EleveStore

    @State
    private var isAddingGroupMark = false

    @State
    private var isShowingResetConfirmDialog = false

    // MARK: - Compute Properties

    private var nbGroupInClasse: Int {
        GroupManager.largestGroupNumber(dans       : classe,
                                        eleveStore : eleveStore)
    }

    var body: some View {
        Section {
            ForEach(filtredMarks()) { $eleveMark in
                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                    MarkView(eleveName : eleve.displayName,
                             maxMark   : exam.maxMark,
                             type      : $eleveMark.type,
                             mark      : $eleveMark.mark)
                }
            }
        } header: {
            HStack {
                Text("Notes")
                Spacer()

                /// reset de toutes les notes de la classe
                Button(role: .destructive) {
                    isShowingResetConfirmDialog = true
                } label: {
                    Image(systemName: "person.3.fill")
                }
                /// Confirmation de Suppression de toutes vos données
                .confirmationDialog("Remettre toutes les notes à \"Non rendu\" ?",
                                    isPresented: $isShowingResetConfirmDialog,
                                    titleVisibility : .visible) {
                    Button("Poursuivre", role: .destructive) {
                        withAnimation {
                            self.resetAllMarks()
                        }
                    }
                } message: {
                    Text("Cette action ne peut pas être annulée.")
                }

                /// affecter la même note à tous les membres d'un même groupe
                if nbGroupInClasse.isPositive {
                    Button {
                        isAddingGroupMark = true
                    } label: {
                        Image(systemName: "person.line.dotted.person.fill")
                    }
                }
            }
        }
        .headerProminence(.increased)
        .sheet(isPresented: $isAddingGroupMark) {
            NavigationStack {
                GroupMarkDialog(exam           : $exam,
                                maxMark        : exam.maxMark,
                                nbGroupInClasse: nbGroupInClasse)
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Methods

    private func filtredMarks() -> Binding<[EleveMark]> {
        Binding<[EleveMark]>(
            get: {
                self.exam.marks
                    .filter { eleveMark in
                        if searchString.isNotEmpty {
                            if searchString.containsOnlyDigits {
                                // filtrage sur numéro de groupe
                                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                                    let groupNum = Int(searchString)!
                                    return eleve.group == groupNum
                                } else {
                                    return false
                                }

                            } else {
                                // filtrage sur Nom ou Prénom
                                if let eleve = eleveStore.item(withID: eleveMark.eleveId) {
                                    let string = searchString.lowercased()
                                    return eleve.name.familyName!.lowercased().contains(string) ||
                                    eleve.name.givenName!.lowercased().contains(string)
                                } else {
                                    return false
                                }
                            }
                        } else {
                            return true
                        }
                    }
            },
            set: { items in
                for eleveMark in items {
                    if let index = self.exam.marks.firstIndex(where: { $0.eleveId == eleveMark.eleveId }) {
                        self.exam.marks[index] = eleveMark
                    }
                }
            }
        )
    }

    private func resetAllMarks() {
        withAnimation {
            for idx in exam.marks.indices {
                exam.marks[idx].type = .nonRendu
            }
        }
    }
}

/// Saisie la de la note dun groupe pour une évaluation
struct GroupMarkDialog : View {
    @Binding
    var exam: Exam

    let maxMark         : Int
    let nbGroupInClasse : Int

    @EnvironmentObject
    private var eleveStore: EleveStore

    @Environment(\.dismiss) private var dismiss

    @State private var mark     : Double = 0
    @State private var groupeNb : Int = 0

    private var grpRange: Range<Int> {
        1 ..< (nbGroupInClasse+1)
    }

    @State private var grpTable = [Int]()

    var body: some View {
        Form {
            HStack {
                AmountEditView(label    : "Note",
                               amount   : $mark,
                               validity : .within(range: 0.0 ... Double(maxMark)),
                               currency : false)
                Stepper(
                    "",
                    value : $mark,
                    in    : 0...20,
                    step  : 0.5
                )
                .frame(maxWidth: 100)
            }
            Picker("Groupe", selection: $groupeNb) {
                ForEach(grpTable, id: \.self) { grp in
                    Label(String(grp), systemImage: "person.line.dotted.person.fill")
                }
            }
            .pickerStyle(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("Attribuer") {
                    attribuer(note: mark, auGroupe: groupeNb)
                    dismiss()
                }
            }
        }
        .task {
            mark = Double(maxMark)
            grpRange.forEach {
                grpTable.append($0)
            }
        }
    }

    // MARK: - Methods

    func attribuer(note: Double, auGroupe: Int) {
        withAnimation {
            for idx in exam.marks.indices {
                let eleveId = exam.marks[idx].eleveId
                if let group = eleveStore.item(withID: eleveId)?.group, group == auGroupe {
                    exam.marks[idx].type = .note
                    exam.marks[idx].mark = note
                }
            }
        }
    }
}

//struct MarkListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            List {
//                MarkListView(exam: .constant(Exam.exemple), searchString: "")
//            }
//            .previewDevice("iPad mini (6th generation)")
//
//            List {
//                MarkListView(exam: .constant(Exam.exemple), searchString: "")
//            }
//            .previewDevice("iPhone 13")
//        }
//    }
//}
