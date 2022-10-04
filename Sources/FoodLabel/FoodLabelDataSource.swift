import Foundation
import PrepUnits
import FoodLabelScanner

public protocol FoodLabelDataSource: ObservableObject {
    var energyValue: FoodLabelValue { get }
    var carbAmount: Double { get }
    var fatAmount: Double { get }
    var proteinAmount: Double { get }

    var nutrients: [NutrientType: Double] { get }
    var showFooterText: Bool { get }
    var showRDAValues: Bool { get }
    
    var amountPerString: String { get }
}

extension FoodLabelDataSource {
//    var nutrients: [NutrientType: Double] {
//        [:]
//    }
    
    var showFooterText: Bool {
        true
    }
    
    var showRDAValues: Bool {
        true
    }
}
