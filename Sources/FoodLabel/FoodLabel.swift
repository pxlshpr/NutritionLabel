import SwiftUI
import SwiftHaptics
import PrepDataTypes
import FoodLabelScanner

public struct FoodLabel: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var energyValue: FoodLabelValue
    @Binding var carb: Double
    @Binding var fat: Double
    @Binding var protein: Double
    @Binding var nutrients: [NutrientType:Double]
    @Binding var amountPerString: String
    
    let showFooterText: Bool
    let showRDAValues: Bool
    let allowTapToChangeEnergyUnit: Bool
    let numberOfDecimalPlaces: Int
    
    let shouldShowCustomMicronutrients: Bool = false
    
    @State var showingEnergyInCalories: Bool
    
    public init(
        energyValue: Binding<FoodLabelValue>,
        carb: Binding<Double>,
        fat: Binding<Double>,
        protein: Binding<Double>,
        nutrients: Binding<[NutrientType:Double]>,
        amountPerString: Binding<String>,
        
        showFooterText: Bool = false,
        showRDAValues: Bool = false,
        allowTapToChangeEnergyUnit: Bool = false,
        numberOfDecimalPlaces: Int = 1
    ) {
        _energyValue = energyValue
        _carb = carb
        _fat = fat
        _protein = protein
        _nutrients = nutrients
        _amountPerString = amountPerString
        
        self.showFooterText = showFooterText
        self.showRDAValues = showRDAValues
        self.allowTapToChangeEnergyUnit = allowTapToChangeEnergyUnit
        self.numberOfDecimalPlaces = numberOfDecimalPlaces
        
        let isKcal = energyValue.wrappedValue.unit != FoodLabelUnit.kj
        _showingEnergyInCalories = State(initialValue: isKcal)
    }
    
    public var body: some View {
        //TODO: Spacing here seems to fix the lines issue
        VStack(alignment: .leading, spacing: 0) {
            header
            calories
            if showRDAValues {
                Spacer().frame(height: 3)
            }
            macros
            if shouldShowMicronutrients {
                macrosMicrosSeparator
                micros
            }
            if shouldShowCustomMicronutrients {
                microsCustomSeparator
                customMicros
            }
            if showFooterText {
                footer
            }
        }
        .padding(15)
        .border(borderColor, width: 5.0)
        .onChange(of: energyValue) { newValue in
            
            let shouldToggle: Bool
            if newValue.unit == .kj {
                shouldToggle = showingEnergyInCalories
            } else {
                shouldToggle = !showingEnergyInCalories
            }
            if shouldToggle {
                withAnimation {
                    showingEnergyInCalories.toggle()
                }
            }
        }
    }
    
    var shouldShowMicronutrients: Bool {
        !nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
    }

    func nutrientAmount(for type: NutrientType) -> Double? {
        nutrients[type]
    }
}

//public struct FoodLabelPreview: View {
//
//    class ViewModel: ObservableObject {
//
//    }
//
//    @StateObject var viewModel = ViewModel()
//    public var body: some View {
//        FoodLabel(dataSource: viewModel)
//            .frame(width: 350)
//    }
//    public init() { }
//}

extension FoodLabel {
    func rectangle(height: CGFloat) -> some View {
//        Rectangle()
//            .frame(height: height)
//            .foregroundColor(borderColor)
//        borderColor
//            .frame(height: height)
        GeometryReader { geometry in
            Path() { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: geometry.size.width, y: height))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
//                path.addLine(to: CGPoint(x: 200, y: height))
//                path.addLine(to: CGPoint(x: 200, y: 0))
                path.closeSubpath()
            }
            .fill(borderColor)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, 5)
//        .background(.yellow)
    }
    
    var fatRows: some View {
        Group {
            
            row(title: "Total Fat",
                value: fat,
                rdaValue: MacroRDA.fat,
                unit: "g",
                bold: true,
                /// Don't include a divider above Fat if we're not showing RDA values as there won't be a % Daily VAlue header to have in it
                includeDivider: showRDAValues
            )
            nutrientRow(forType: .saturatedFat, indentLevel: 1)
            nutrientRow(forType: .polyunsaturatedFat, indentLevel: 1)
            nutrientRow(forType: .monounsaturatedFat, indentLevel: 1)
            nutrientRow(forType: .transFat, indentLevel: 1)
        }
    }
    
    func row(title: String, prefix: String? = nil, value: Double, rdaValue: Double? = nil, unit: String = "g", indentLevel: Int = 0, bold: Bool = false, includeDivider: Bool = true, prefixedWithIncludes: Bool = false) -> some View {
        let prefixView = Group {
            if let prefix = prefix {
                Text(prefix)
                    .fontWeight(.regular)
                    .font(.headline)
                    .italic()
                    .foregroundColor(.primary)
                Spacer().frame(width: 3)
            }
        }
        
        let titleView = Group {
            HStack(spacing: 0) {
                prefixView
                Text(title)
                    .fontWeight(bold ? .black : .regular)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        
        let valueAndSuffix = Group {
            Text(valueString(for: value, with: unit))
                .fontWeight(.regular)
                .font(.headline)
                .foregroundColor(.primary)
        }
        
        let divider = Group {
            HStack {
                if indentLevel > 1 {
                    Spacer().frame(width: CGFloat(indentLevel) * 20.0)
                }
                VStack {
                    rectangle(height: 0.3)
//                    Spacer().frame(height: 0)
                }
            }
            .frame(height: 6.0)
        }
        
        return VStack(spacing: 0) {
            if includeDivider {
                divider
            } else {
                Spacer().frame(height: 5)
            }
            HStack {
                if indentLevel > 0 {
                    Spacer().frame(width: CGFloat(indentLevel) * 20.0)
                }
                VStack {
                    HStack {
                        if prefixedWithIncludes {
                            Text("Includes  \(valueString(for: value, with: unit))  \(title)")
                                .foregroundColor(.primary)
                        } else {
                            titleView
                            valueAndSuffix
                        }
                        Spacer()
                        if rdaValue != nil, showRDAValues {
                            Text("\(Int((value/rdaValue!)*100.0))%")
                                .fontWeight(.bold)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            Spacer().frame(height: 5)
        }
    }
    
    var microsCustomSeparator: some View {
        Group {
            Spacer().frame(height: 6)
            rectangle(height: 8)
        }
    }
    
    var macrosMicrosSeparator: some View {
        Group {
            rectangle(height: 15)
            Spacer().frame(height: 5)
        }
    }
}

//extension FoodLabelPreview.ViewModel: FoodLabelDataSource {
//    var amountPerString: String {
//        "1 serving (1 cup, chopped)"
//    }
//    
//    var nutrients: [NutrientType : Double] {
//        [
//            .saturatedFat: 5,
//            .addedSugars: 35,
//            .vitaminB7_biotin: 10.5,
////            .transFat: 50,
////            .monounsaturatedFat: 20
//        ]
//    }
//    
//    var showRDAValues: Bool {
//        false
//    }
//    
//    var showFooterText: Bool {
//        false
//    }
//    
//    var energyValue: FoodLabelValue {
//        FoodLabelValue(amount: 235, unit: .kj)
//    }
//    
//    var carbAmount: Double {
//        45.5
//    }
//    
//    var fatAmount: Double {
//        8
//    }
//    
//    var proteinAmount: Double {
//        12
//    }
//}
//
//struct FoodLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodLabelPreview()
//    }
//}
