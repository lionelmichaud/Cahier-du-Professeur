/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Files

struct LoadableImage: View {
    var imageUrl: URL
    @State private var placeholderPortrait: Image = Image(systemName: "person.fill.questionmark")
    
    var body: some View {
        VStack {
//            PlaceholderPortrait(portrait: $placeholderPortrait)
//                .draggable(placeholderPortrait)
//                .dropDestination(for: Image.self) { (images: [Image], _) in
//                    if let portrait = images.first {
//                        placeholderPortrait = portrait
//                        return true
//                    }
//                    return false
//                }
//            PasteButton(payloadType: Image.self) { images in
//                placeholderPortrait = images.first!
//            }

            AsyncImage(url: imageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .accessibility(hidden: false)

                } else if phase.error != nil {
                    PlaceholderPortrait(portrait: $placeholderPortrait)
//                        .draggable(placeholderPortrait)
                        .dropDestination(for: Image.self) { (images: [Image], _) in
                            if let portrait = images.first {
                                placeholderPortrait = portrait
                                return true
                            }
                            return false
                        }
                } else {
                    ProgressView()
                }
            }
        }
    }
}

struct PlaceholderPortrait : View {
    @Binding var portrait: Image
    
    var body: some View {
        VStack {
            portrait
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100)
//            PasteButton(payloadType: Image.self) { images in
//                portrait = images.first!
//            }
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
