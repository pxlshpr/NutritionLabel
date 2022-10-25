import SwiftUI
import PrepDataTypes

extension FoodLabel {
    
    var borderColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var formattedEnergy: String {
        let amount = showingEnergyInCalories ? dataSource.energyValue.energyAmountInCalories : dataSource.energyValue.energyAmountInKilojoules
        return "\(Int(amount))"
    }

    func valueString(for value: Double, with unit: String) -> String {
        guard dataSource.numberOfDecimalPlaces == 0 else {
            return "\(value.rounded(toPlaces: dataSource.numberOfDecimalPlaces).cleanAmount)" + unit
        }
        
        if value < 0.5 {
            if value == 0 {
                return "0" + unit
            } else if value < 0.1 {
                return "< 0.1" + unit
            } else {
                return "\(String(format: "%.1f", value))" + unit
            }
        } else {
            return "\(Int(value))" + unit
        }
    }
}
