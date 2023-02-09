import SwiftUI
import SwiftHaptics

extension FoodLabel {
    var header: some View {
        Group {
            nutritionFactsRow
            Spacer().frame(height: 6)
            amountPerRow
            Spacer().frame(height: 10)
            rectangle(height: 15)
            Spacer().frame(height: 12)
        }
    }
    
    var calories: some View {
        Group {
            caloriesRow
            Spacer().frame(height: 10)
            rectangle(height: 8)
            if showRDAValues {
                Spacer().frame(height: 6)
            }
        }
    }
    
    var macros: some View {
        Group {
            percentHeaderRow
            fatRows
            highlightedMacroRows
            carbRows
            proteinRow
        }
    }
    
    var micros: some View {
        Group {
            vitaminRows
            mineralRows
            miscRows
        }
    }
    
    var customMicros: some View {
        customNutrientRows
    }

    var footer: some View {
        Group {
            Spacer().frame(height: 3)
            rectangle(height: 8)
            Spacer().frame(height: 12)
            HStack(alignment: .top, spacing: 0) {
                Text("*")
                Text("The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.")
            }
            .foregroundColor(.primary)
            .font(.footnote)
            Spacer().frame(height: 9)
        }
    }
    
    //MARK: - Header Rows
    
    var nutritionFactsRow: some View {
        Text("Nutrition Facts")
            .fontWeight(.black)
            .font(.largeTitle)
            .foregroundColor(.primary)
    }
    
    var amountPerRow: some View {
        HStack(alignment: .top, spacing: 5) {
            Text("Amount per")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(.primary)
            Spacer()
            Color.clear
                .animatedQuantity(
                    value: data.quantityValue,
                    unitString: data.quantityUnit,
                    isAnimating: true
                )
//            Text("\(data.quantityValue.cleanAmount) \(data.quantityUnit)")
//                .fontWeight(.bold)
//                .font(.title3)
//                .multilineTextAlignment(.trailing)
//                .foregroundColor(.primary)
//                .lineLimit(3)
        }
    }
    
    var caloriesRow: some View {
        HStack(alignment: .bottom) {
            Text(showingEnergyInCalories ? "Calories" : "Energy")
                .fontWeight(.black)
                .font(.title)
                .foregroundColor(.primary)
                .transition(.opacity)
            Spacer()
//            labelCaloriesAmount
            labelCaloriesAmountAnimated
        }
        .if(allowTapToChangeEnergyUnit, transform: { view in
            view
                .onTapGesture {
                    Haptics.feedback(style: .soft)
                    withAnimation {
                        showingEnergyInCalories.toggle()
                    }
                }
        })
    }
    
    var labelCaloriesAmount: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(formattedEnergy)
                .fontWeight(.black)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
                .transition(.opacity)
            if !showingEnergyInCalories {
                Text("kJ")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .offset(y: 2)
                    .transition(.scale)
            }
        }
    }
    
    @ViewBuilder
    var percentHeaderRow: some View {
        if showRDAValues {
            Group {
                HStack(alignment: .top, spacing: 0) {
                    Spacer()
                    Text("% Daily Value")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .font(.subheadline)
                    Text("*")
                        .font(.caption)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
                Spacer().frame(height: 5)
            }
        }
    }
    
    var labelCaloriesAmountAnimated: some View {
        Color.clear
            .animatedEnergyValue(
                value: showingEnergyInCalories
                ? data.energyValue.energyAmountInCalories
                : data.energyValue.energyAmountInKilojoules,
                unitString: showingEnergyInCalories ? "" : "kJ",
                isAnimating: true
            )
    }
}

//MARK: - Extensions (reused and to be moved)
private extension Font.Weight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .medium:
            return .medium
        case .black:
            return .black
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .light:
            return .light
        case .regular:
            return .regular
        case .semibold:
            return .semibold
        case .thin:
            return .thin
        case .ultraLight:
            return .ultraLight
        default:
            return .regular
        }
    }
}

private extension Double {
    var formattedNutrient: String {
        let rounded: Double
        if self < 50 {
            rounded = self.rounded(toPlaces: 1)
        } else {
            rounded = self.rounded()
        }
        return rounded.formattedWithCommas
    }
    
    var formattedMealItemAmount: String {
        let rounded: Double
//        if self < 50 {
//            rounded = self.rounded(toPlaces: 1)
//        } else {
            rounded = self.rounded()
//        }
        return rounded.formattedWithCommas
    }

}

private extension Double {
    var formattedWithCommas: String {
        guard self >= 1000 else {
            return cleanAmount
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value: Int(self))
        
        guard let formatted = numberFormatter.string(from: number) else {
            return "\(Int(self))"
        }
        return formatted
    }
}

//MARK: - Animatable modifiers

//MARK: EnergyValue
struct AnimatableEnergyValueModifier: AnimatableModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var value: Double
    var unitString: String
    var isAnimating: Bool
    
    let fontSize: CGFloat = 34
    let fontWeight: Font.Weight = .black
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var uiFont: UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: fontWeight.uiFontWeight)
    }
    
    var size: CGSize {
        uiFont.fontSize(for: value.formattedNutrient)
    }
    
    let unitFontSize: CGFloat = 20
    let unitFontWeight: Font.Weight = .bold
    
    var unitUIFont: UIFont {
        UIFont.systemFont(ofSize: unitFontSize, weight: unitFontWeight.uiFontWeight)
    }
    
    var unitWidth: CGFloat {
        unitUIFont.fontSize(for: unitString).width
    }
    
    var amountString: String {
        if isAnimating {
            return value.formattedMealItemAmount
        } else {
            return value.cleanAmount
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .overlay(
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Spacer()
                    HStack(alignment: .top, spacing: 0) {
                        Text(amountString)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: fontSize, weight: fontWeight, design: .default))
                        Text(unitString)
                            .font(.system(
                                size: unitFontSize,
                                weight: unitFontWeight,
                                design: .default)
                            )
                            .offset(y: 2)
                    }
                    .foregroundColor(.primary)
                }
            )
    }
}

extension View {
    func animatedEnergyValue(value: Double, unitString: String, isAnimating: Bool) -> some View {
        modifier(AnimatableEnergyValueModifier(value: value, unitString: unitString, isAnimating: isAnimating))
    }
}

//MARK: Value
struct AnimatableValue: AnimatableModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var value: Double
    var unitString: String
    var isAnimating: Bool
    var numberOfDecimalPlaces: Int
    
    let fontSize: CGFloat = 12
    let fontWeight: Font.Weight = .regular
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var uiFont: UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: fontWeight.uiFontWeight)
    }
    
    var size: CGSize {
        uiFont.fontSize(for: value.formattedNutrient)
    }
    
    let unitFontSize: CGFloat = 17
    let unitFontWeight: Font.Weight = .regular
    
    var unitUIFont: UIFont {
        UIFont.systemFont(ofSize: unitFontSize, weight: unitFontWeight.uiFontWeight)
    }
    
    var unitWidth: CGFloat {
        unitUIFont.fontSize(for: unitString).width
    }
    
    var amountString: String {
        if isAnimating {
            return value.formattedMealItemAmount
        } else {
            return value.cleanAmount
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .overlay(
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    if numberOfDecimalPlaces != 0 {
                        if isAnimating {
                            Text("\(value.rounded(toPlaces: 0).cleanAmount)")
                        } else {
                            Text("\(value.rounded(toPlaces: numberOfDecimalPlaces).cleanAmount)")
                        }
                    } else {
                        if value < 0.5 {
                            if value == 0 {
                                Text("0")
                            } else if value < 0.1 {
                                Text("< 0.1")
                            } else {
                                Text("\(String(format: "%.1f", value))")
                            }
                        } else {
                            Text("\(Int(value))")
                        }
                    }
//                        .multilineTextAlignment(.leading)
                    Text(unitString)
                    .font(.system(
                        size: unitFontSize,
                        weight: unitFontWeight,
                        design: .default)
                    )
                    Spacer()
                }
                .foregroundColor(.primary)
            )
    }
}

extension View {
    func animatedValue(value: Double, unitString: String, isAnimating: Bool, numberOfDecimalPlaces: Int = 1) -> some View {
        modifier(AnimatableValue(value: value, unitString: unitString, isAnimating: isAnimating, numberOfDecimalPlaces: numberOfDecimalPlaces))
    }
}

//MARK: "Includes" Value
struct AnimatableIncludedValue: AnimatableModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var value: Double
    var unitString: String
    var isAnimating: Bool
    var numberOfDecimalPlaces: Int
    var title: String
    
    let fontSize: CGFloat = 12
    let fontWeight: Font.Weight = .regular
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var uiFont: UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: fontWeight.uiFontWeight)
    }
    
    var size: CGSize {
        uiFont.fontSize(for: value.formattedNutrient)
    }
    
    let unitFontSize: CGFloat = 17
    let unitFontWeight: Font.Weight = .regular
    
    var unitUIFont: UIFont {
        UIFont.systemFont(ofSize: unitFontSize, weight: unitFontWeight.uiFontWeight)
    }
    
    var unitWidth: CGFloat {
        unitUIFont.fontSize(for: unitString).width
    }
    
    var amountString: String {
        if isAnimating {
            return value.formattedMealItemAmount
        } else {
            return value.cleanAmount
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: size.height + 6.0)
            .overlay(
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("Includes  ")
                        .font(.system(size: unitFontSize, weight: unitFontWeight, design: .default))
                    if numberOfDecimalPlaces != 0 {
                        if isAnimating {
                            Text("\(value.rounded(toPlaces: 0).cleanAmount)")
                        } else {
                            Text("\(value.rounded(toPlaces: numberOfDecimalPlaces).cleanAmount)")
                        }
                    } else {
                        if value < 0.5 {
                            if value == 0 {
                                Text("0")
                            } else if value < 0.1 {
                                Text("< 0.1")
                            } else {
                                Text("\(String(format: "%.1f", value))")
                            }
                        } else {
                            Text("\(Int(value))")
                        }
                    }
                    Text(unitString)
                        .font(.system(size: unitFontSize, weight: unitFontWeight, design: .default))
                    Text("  " + title)
                        .font(.system(size: unitFontSize, weight: unitFontWeight, design: .default))
                    Spacer()
                }
                .foregroundColor(.primary)
            )
    }
}

extension View {
    func animatedIncludedValue(value: Double, unitString: String, isAnimating: Bool, numberOfDecimalPlaces: Int = 1, title: String) -> some View {
        modifier(AnimatableIncludedValue(
            value: value,
            unitString: unitString,
            isAnimating: isAnimating,
            numberOfDecimalPlaces: numberOfDecimalPlaces,
            title: title
        ))
    }
}

//MARK: Quantity

struct AnimatableQuantityModifier: AnimatableModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var value: Double
    var unitString: String
    var isAnimating: Bool
    
    let fontSize: CGFloat = 20
    let fontWeight: Font.Weight = .bold
    
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var uiFont: UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: fontWeight.uiFontWeight)
    }
    
    var size: CGSize {
        uiFont.fontSize(for: value.formattedNutrient)
    }
    
    let unitFontSize: CGFloat = 20
    let unitFontWeight: Font.Weight = .bold
    
    var unitUIFont: UIFont {
        UIFont.systemFont(ofSize: unitFontSize, weight: unitFontWeight.uiFontWeight)
    }
    
    var unitWidth: CGFloat {
        unitUIFont.fontSize(for: unitString).width
    }
    
    var amountString: String {
        if isAnimating {
            return value.formattedMealItemAmount
        } else {
            return value.cleanAmount
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .overlay(
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Spacer()
//                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(amountString)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: fontSize, weight: fontWeight, design: .default))
                        Text(unitString)
                            .font(.system(
                                size: unitFontSize,
                                weight: unitFontWeight,
                                design: .default)
                            )
                            .minimumScaleFactor(0.2)
                            .lineLimit(3)
//                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundColor(.primary)
                }
            )
    }
}

extension View {
    func animatedQuantity(value: Double, unitString: String, isAnimating: Bool) -> some View {
        modifier(AnimatableQuantityModifier(
            value: value,
            unitString: unitString,
            isAnimating: isAnimating
        ))
    }
}
