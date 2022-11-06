//
//  PdfDocumentViewer.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 02/11/2022.
//

import SwiftUI

struct PdfDocumentViewer: View {
    var document: Document

    @Environment(\.dismiss) private var dismiss

    // MARK: - Computed Properties

    private var pdfImage: Image {
        let uiImage = drawPDFfromURL(url: document.url)
        if let uiImage {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "doc.richtext").resizable()
        }
    }

    var body: some View {
        ScrollView([.vertical,.horizontal],
                   showsIndicators: true) {
            pdfImage
        }
         #if os(iOS)
        .navigationTitle("\(document.docName)")
        .navigationBarTitleDisplayMode(.inline)
         #endif
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Methods

    /// Retourne une Image créée à partir d'un document PDF.
    /// - Parameter url: URL du document PDF à convertir
    /// - Returns: Image créée à partir d'un document PDF
    // TODO: - Ajouter la possibilité multi-pages
    private func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
}

//struct PdfDocumentViewer_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfDocumentViewer()
//    }
//}
