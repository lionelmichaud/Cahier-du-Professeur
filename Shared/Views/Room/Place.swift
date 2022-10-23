//
//  Place.swift
//  Cahier du Professeur
//
//  Created by Lionel MICHAUD on 23/10/2022.
//

import SwiftUI

struct Place: View {
    var position: CGPoint
    var text : String?

    private let backgoundColor = Color.blue
    private let foregoundColor = Color.white

    var body: some View {
        Group {
            if let text {
                Text(text)
                    .foregroundColor(foregoundColor)
            } else {
                Text("Wandrille")
                    .foregroundColor(backgoundColor)
            }
        }
        .padding(2)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(backgoundColor)
        }
    }
}

struct Place_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Place(position: CGPoint(x: 0.5, y: 0.5), text: "Une place")
                .previewLayout(.fixed(width: 400, height: 400))
            Place(position: CGPoint(x: 0.5, y: 0.5), text: nil)
                .previewLayout(.fixed(width: 400, height: 400))
        }
    }
}
