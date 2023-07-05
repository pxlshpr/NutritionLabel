import SwiftUI
import SwiftHaptics
import FoodDataTypes
//import FoodLabelScanner

public struct FoodLabelData {
    let energyValue: FoodLabelValue
    let carb: Double
    let fat: Double
    let protein: Double
    let nutrients: [Micro : FoodLabelValue]
    let quantityValue: Double
    let quantityUnit: String
    
    let showRDA: Bool
    let customRDAValues: [Nutrient: (Double, NutrientUnit)]
    let dietName: String?

    public init(
        energyValue: FoodLabelValue,
        carb: Double,
        fat: Double,
        protein: Double,
        nutrients: [Micro : FoodLabelValue],
        quantityValue: Double,
        quantityUnit: String,
        showRDA: Bool = false,
        customRDAValues: [Nutrient: (Double, NutrientUnit)] = [:],
        dietName: String? = nil
    ) {
        self.energyValue = energyValue
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.nutrients = nutrients
        self.quantityValue = quantityValue
        self.quantityUnit = quantityUnit
        self.showRDA = showRDA
        self.customRDAValues = customRDAValues
        self.dietName = dietName
    }
}

public struct FoodLabel: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Binding var data: FoodLabelData
    let allowTapToChangeEnergyUnit: Bool
    let numberOfDecimalPlaces: Int
    
    let shouldShowCustomMicronutrients: Bool = false
    
    let didTapFooter: (() -> ())?
    @State var showingEnergyInCalories: Bool
    
    public init(
        data: Binding<FoodLabelData>,
        didTapFooter: (() -> ())? = nil,
        allowTapToChangeEnergyUnit: Bool = false,
        numberOfDecimalPlaces: Int = 1
    ) {
        _data = data
        self.didTapFooter = didTapFooter
        self.allowTapToChangeEnergyUnit = allowTapToChangeEnergyUnit
        self.numberOfDecimalPlaces = numberOfDecimalPlaces
        
        let isKcal = data.wrappedValue.energyValue.unit != FoodLabelUnit.kj
        _showingEnergyInCalories = State(initialValue: isKcal)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            calories
            if data.showRDA {
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
            if data.showRDA {
                footer
            }
        }
        .padding(15)
        .border(borderColor, width: 5.0)
        .onChange(of: data.energyValue) { newValue in
            
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
        !data.nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
    }

    func nutrientValue(for type: Micro) -> FoodLabelValue? {
        data.nutrients[type]
    }
}

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
    
    func row(
        title: String,
        prefix: String? = nil,
        value: Double,
        rdaValue: Double? = nil,
        usingCustomRDA: Bool = false,
        unit: String = "g",
        indentLevel: Int = 0,
        bold: Bool = false,
        includeDivider: Bool = true,
        prefixedWithIncludes: Bool = false
    ) -> some View {
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
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
//        let valueAndSuffix = Group {
//            Color.clear
//                .animatedValue(
//                    value: value,
//                    unitString: unit,
//                    isAnimating: true
//                )
//        }

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
        
        var animatedIncludedValue: some View {
            Color.clear
                .animatedIncludedValue(
                    value: value,
                    unitString: unit,
                    isAnimating: true,
                    title: title
                )
        }
        
        var animatedValueWithLabel: some View {
            Color.clear
                .animatedValueWithLabel(
                    title: title,
                    boldTitle: bold,
                    prefix: prefix,
                    value: value,
                    unitString: unit,
                    isAnimating: true,
                    numberOfDecimalPlaces: numberOfDecimalPlaces
                )
        }
        
        func rdaLabel(_ rdaValue: Double) -> some View {
            @ViewBuilder
            var marker: some View {
                if usingCustomRDA {
                    Text("†")
                        .fontWeight(.light)
                }
            }
            
            var percent: Double {
                guard rdaValue > 0 else { return 0 }
                return (value/rdaValue) * 100.0
            }
            
            return HStack(alignment: .top, spacing: 2) {
                Color.clear
                    .animatedRDAValue(
                        value: percent,
                        isAnimating: true
                    )
                marker
                    .font(.footnote)
                    .offset(y: -2)
            }
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
                            animatedIncludedValue
                        } else {
                            animatedValueWithLabel
                        }
                        Spacer()
                        if let rdaValue, rdaValue > 0, data.showRDA {
                            rdaLabel(rdaValue)
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
//    var nutrients: [Micro : Double] {
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
