import Foundation
import PrepUnits

public protocol FoodLabelDataSource: ObservableObject {
    var energyAmount: Double { get }
    var carbAmount: Double { get }
    var fatAmount: Double { get }
    var proteinAmount: Double { get }

    var nutrients: [NutrientType: Double] { get }
    var showFooterText: Bool { get }
    var showRDAValues: Bool { get }
    
    //Legacy
    var haveMicros: Bool { get }
    var haveCustomMicros: Bool { get }
    func nutrient(ofType: NutrientType) -> Double?
    var amountString: String { get }
}

extension FoodLabelDataSource {
    var nutrients: [NutrientType: Double] {
        [:]
    }
    
    var showFooterText: Bool {
        true
    }
    
    var showRDAValues: Bool {
        true
    }
}
