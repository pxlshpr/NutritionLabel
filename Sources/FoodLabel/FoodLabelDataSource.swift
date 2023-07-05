//import Foundation
//import FoodDataTypes
//import FoodLabelScanner
//
//public protocol FoodLabelDataSource: ObservableObject {
//    var energyValue: FoodLabelValue { get }
//    var carbAmount: Double { get }
//    var fatAmount: Double { get }
//    var proteinAmount: Double { get }
//
//    var nutrients: [Micro: Double] { get }
//    var showFooterText: Bool { get }
//    var showRDAValues: Bool { get }
//    var allowTapToChangeEnergyUnit: Bool { get }
//    
//    var amountPerString: String { get }
//    var numberOfDecimalPlaces: Int { get }
//}
//
//public extension FoodLabelDataSource {
//    
//    var numberOfDecimalPlaces: Int {
//        1
//    }
//    
//    var allowTapToChangeEnergyUnit: Bool {
//        true
//    }
//    
//    var showFooterText: Bool {
//        true
//    }
//    
//    var showRDAValues: Bool {
//        true
//    }
//    
//    var shouldShowMicronutrients: Bool {
//        !nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
//    }
//    
//    var shouldShowCustomMicronutrients: Bool {
//        //TODO: Fix this when custom micros are brought back
//        false
//    }
//    
//    func nutrientAmount(for type: Micro) -> Double? {
//        nutrients[type]
//    }
//}
