/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Files

struct LoadableImage: View {
    var imageUrl: URL
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .accessibility(hidden: false)
            }  else if phase.error != nil  {
                VStack {
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100)
                    Text("Photo introuvable.")
                }
                
            } else {
                ProgressView()
            }
        }
    }
}

struct LoadableImage_Previews: PreviewProvider {
    static func testImageUrl() -> URL {
        return try! Folder.application!.file(named: "test_image.jpg").url
    }
    static var previews: some View {
        LoadableImage(imageUrl: testImageUrl())
    }
}
