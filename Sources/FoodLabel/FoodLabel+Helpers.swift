import SwiftUI
import PrepUnits

extension FoodLabel {
    
    var borderColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    func rectangle(height: CGFloat) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(borderColor)
    }
    
    var formattedEnergy: String {
        let amount = showingEnergyInCalories ? dataSource.energyValue.energyAmountInCalories : dataSource.energyValue.energyAmountInKilojoules
        return "\(Int(amount))"
    }

    func row(title: String, prefix: String? = nil, value: Double, rdaValue: Double? = nil, unit: String = "g", indentLevel: Int = 0, bold: Bool = false, includeDivider: Bool = true, prefixedWithIncludes: Bool = false) -> some View {
        let prefixView = Group {
            if let prefix = prefix {
                Text(prefix)
                    .fontWeight(.regular)
                    .font(.headline)
                    .italic()
                Spacer().frame(width: 3)
            }
        }
        
        let titleView = Group {
            HStack(spacing: 0) {
                prefixView
                Text(title)
                    .fontWeight(bold ? .black : .regular)
                    .font(.headline)
            }
        }
        
        let valueAndSuffix = Group {
            Text(valueString(for: value, with: unit))
                .fontWeight(.regular)
                .font(.headline)
        }
        
        let divider = Group {
            HStack {
                if indentLevel > 1 {
                    Spacer().frame(width: CGFloat(indentLevel) * 20.0)
                }
                VStack {
                    rectangle(height: 0.3)
                    Spacer().frame(height: 5)
                }
            }
            .frame(height: 6.0)
        }
        
        return VStack(spacing: 0) {
            if includeDivider {
                divider
            }
//            Spacer().frame(height: 2)
            HStack {
                if indentLevel > 0 {
                    Spacer().frame(width: CGFloat(indentLevel) * 20.0)
                }
                VStack {
                    HStack {
                        if prefixedWithIncludes {
                            Text("Includes  \(valueString(for: value, with: unit))  \(title)")
                        } else {
                            titleView
                            valueAndSuffix
                        }
                        Spacer()
                        if rdaValue != nil, dataSource.showRDAValues {
                            Text("\(Int((value/rdaValue!)*100.0))%")
                                .fontWeight(.bold)
                                .font(.headline)
                        }
                    }
                }
            }
            Spacer().frame(height: 5)
        }
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
