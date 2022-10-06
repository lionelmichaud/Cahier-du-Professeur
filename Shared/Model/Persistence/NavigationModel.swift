/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A navigation model used to persist and restore the navigation state.
*/

import SwiftUI
import Combine

final class NavigationModel: ObservableObject, Codable {
    @Published var selectedTab      : UIState.Tab
    @Published var selectedObservId : Observation.ID?
    @Published var selectedColleId  : Colle.ID?
//    @Published var recipePath: [Recipe]
    @Published var columnVisibility: NavigationSplitViewVisibility
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    init(columnVisibility : NavigationSplitViewVisibility = .doubleColumn,
         selectedTab      : UIState.Tab                   = .school,
         selectedObservId : Observation.ID?               = nil,
         selectedColleId  : Colle.ID?                     = nil
//         recipePath       : [Recipe]                      = []
    ) {
        self.columnVisibility = columnVisibility
        self.selectedTab      = selectedTab
        self.selectedObservId = selectedObservId
        self.selectedColleId  = selectedColleId
//        self.recipePath     = recipePath
    }

//    var selectedRecipe: Recipe? {
//        get { recipePath.first }
//        set { recipePath = [newValue].compactMap { $0 } }
//    }

    var jsonData: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let data = newValue,
                  let model = try? decoder.decode(Self.self, from: data)
            else { return }
            selectedTab      = model.selectedTab
            selectedObservId = model.selectedObservId
            selectedColleId  = model.selectedColleId
//            recipePath     = model.recipePath
            columnVisibility = model.columnVisibility
        }
    }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedTab = try container.decode(
            UIState.Tab.self, forKey: .selectedTab)

        self.selectedObservId = try container.decodeIfPresent(
            Observation.ID.self, forKey: .selectedObservId)

        self.selectedColleId = try container.decodeIfPresent(
            Colle.ID.self, forKey: .selectedColleId)

//        let recipePathIds = try container.decode(
//            [Recipe.ID].self, forKey: .recipePathIds)
//        self.recipePath = recipePathIds.compactMap { DataModel.shared[$0] }
        
        self.columnVisibility = try container.decode(
            NavigationSplitViewVisibility.self, forKey: .columnVisibility)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(selectedTab, forKey: .selectedTab)
        try container.encodeIfPresent(selectedObservId, forKey: .selectedObservId)
        try container.encodeIfPresent(selectedColleId, forKey: .selectedColleId)
//        try container.encode(recipePath.map(\.id), forKey: .recipePathIds)
        try container.encode(columnVisibility, forKey: .columnVisibility)
    }

    enum CodingKeys: String, CodingKey {
        case selectedTab
        case selectedObservId
        case selectedColleId
//        case recipePathIds
        case columnVisibility
    }
}
