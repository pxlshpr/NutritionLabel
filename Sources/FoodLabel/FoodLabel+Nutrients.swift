import SwiftUI
import PrepDataTypes

extension NutrientType {
    var foodLabelDescription: String {
        if let letter = vitaminLetterName {
            return "Vitamin \(letter)"
        } else if self == .transFat {
            return "Fat" /// We'll be prefixing `Trans` in a separate text
        } else {
            return description
        }
    }
}
extension FoodLabel {
    
    var carbRows: some View {
        var carbRow: some View {
            var rdaValue: Double {
                data.customRDAValues[.macro(.carb)]?.0 ?? MacroRDA.carb
            }

            return row(
                title: "Total Carbohydrate",
                value: data.carb,
                rdaValue: rdaValue,
                usingCustomRDA: data.customRDAValues[.macro(.carb)] != nil,
                unit: "g",
                bold: true
            )
        }
        
        return Group {
            carbRow
            nutrientRow(forType: .dietaryFiber, indentLevel: 1)
            nutrientRow(forType: .solubleFiber, indentLevel: 2)
            nutrientRow(forType: .insolubleFiber, indentLevel: 2)
            nutrientRow(forType: .sugars, indentLevel: 1)
            nutrientRow(forType: .addedSugars, indentLevel: 2, prefixedWithIncludes: true) /// Displays as "Includes xg Added Sugar"
            nutrientRow(forType: .sugarAlcohols, indentLevel: 2)
        }
    }
    
    var fatRows: some View {
        var fatRow: some View {
            var rdaValue: Double {
                data.customRDAValues[.macro(.fat)]?.0 ?? MacroRDA.fat
            }

            return row(title: "Total Fat",
                value: data.fat,
                rdaValue: rdaValue,
                usingCustomRDA: data.customRDAValues[.macro(.fat)] != nil,
                unit: "g",
                bold: true,
                /// Don't include a divider above Fat if we're not showing RDA values as there won't be a % Daily VAlue header to have in it
                includeDivider: data.showRDA
            )
        }
        return Group {
            fatRow
            nutrientRow(forType: .saturatedFat, indentLevel: 1)
            nutrientRow(forType: .polyunsaturatedFat, indentLevel: 1)
            nutrientRow(forType: .monounsaturatedFat, indentLevel: 1)
            nutrientRow(forType: .transFat, indentLevel: 1)
        }
    }
    
    var proteinRow: some View {
        var rdaValue: Double {
            data.customRDAValues[.macro(.protein)]?.0 ?? MacroRDA.protein
        }
        
        return row(
            title: "Protein",
            value: data.protein,
            rdaValue: rdaValue,
            usingCustomRDA: data.customRDAValues[.macro(.protein)] != nil,
            unit: "g",
            bold: true
        )
    }
    
    func nutrientRow(forType type: NutrientType, indentLevel: Int = 0, prefixedWithIncludes: Bool = false) -> some View {
        let prefix = type == .transFat ? "Trans" : nil
        let title = type.foodLabelDescription
        let bold = type == .cholesterol || type == .sodium
        
        func rdaValue(in unit: FoodLabelUnit?) -> Double? {
            guard let rdaValue = data.customRDAValues[.micro(type)] ?? type.dailyValue else {
                return nil
            }
            
            if let unit {
                return rdaValue.1.convert(rdaValue.0, to: unit)
            } else {
                return rdaValue.0
            }
            
        }
        
        return Group {
            if let value = nutrientValue(for: type) {
                row(title: title,
                    prefix: prefix,
                    value: value.amount,
                    rdaValue: rdaValue(in: value.unit),
                    usingCustomRDA: data.customRDAValues[.micro(type)] != nil,
                    unit: value.unit?.description ?? "",
                    indentLevel: indentLevel,
                    bold: bold,
                    prefixedWithIncludes: prefixedWithIncludes
                )
            }
        }
    }

    //TODO: Custom Nutrients
//    @ViewBuilder
//    func customNutrientRow(forType type: CustomNutrientType) -> some View {
//        if let value = dataSource.nutrient(ofCustomType: type) {
//            row(title: type.name ?? "",
//                value: value,
//                unit: type.unit?.shortDescription ?? "g"
//            )
//        }
//    }

    var highlightedMacroRows: some View {
        Group {
            nutrientRow(forType: .cholesterol, indentLevel: 0)
            nutrientRow(forType: .sodium, indentLevel: 0)
        }
    }
    

    var vitaminRows: some View {
        Group {
            ForEach(NutrientType.vitamins, id: \.self) {
                nutrientRow(forType: $0)
            }
        }
    }
    
    var mineralRows: some View {
        Group {
            ForEach(NutrientType.minerals.filter { $0 != .sodium }, id: \.self) {
                nutrientRow(forType: $0)
            }
        }
    }
    
    var miscRows: some View {
        Group {
            ForEach(NutrientType.misc, id: \.self) {
                nutrientRow(forType: $0)
            }
        }
    }
    
    var customNutrientRows: some View {
        //TODO:
        EmptyView()
//        Group {
//            ForEach(Store.customNutrientTypes(), id: \.self) {
//                customNutrientRow(forType: $0)
//            }
//        }
    }

}
