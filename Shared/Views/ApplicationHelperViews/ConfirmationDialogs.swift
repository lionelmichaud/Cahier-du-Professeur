//
//  ConfirmationDialogs.swift
//  Patrimonio
//
//  Created by Lionel MICHAUD on 09/05/2022.
//

import SwiftUI

struct ConfirmationDialogs: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ButtonConfirmImportFiles: View {
    @State private var isShowingDialog = false
    var title: String
    var body: some View {
        Button("L'importation va remplacer vos données actuelles par celles contenues dans l'Application.") {
            isShowingDialog = true
        }
        .confirmationDialog(
            title,
            isPresented: $isShowingDialog
        ) {
            Button("Importer", role: .destructive) {
                // Handle empty trash action.
            }
        } message: {
            Text("Cette opération est irréversible.")
        }
    }
}

struct ConfirmEraseItems: View {
    @State private var isShowingDialog = false
    var title: String
    var body: some View {
        Button("Empty Trash") {
            isShowingDialog = true
        }
        .confirmationDialog(
            title,
            isPresented: $isShowingDialog
        ) {
            Button("Empty Trash", role: .destructive) {
                // Handle empty trash action.
            }
            Button("Cancel", role: .cancel) {
                isShowingDialog = false
            }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

struct ConfirmationDialogs_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogs()
    }
}
