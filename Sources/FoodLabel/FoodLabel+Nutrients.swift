import SwiftUI
import PrepDataTypes

extension FoodLabel {
    
    var proteinRow: some View {
        row(title: "Protein", value: protein, rdaValue: MacroRDA.protein, unit: "g", bold: true)
    }
    
    @ViewBuilder
    func nutrientRow(forType type: NutrientType, indentLevel: Int = 0, prefixedWithIncludes: Bool = false) -> some View {
        let prefix = type == .transFat ? "Trans" : nil
        let title = type == .transFat ? "Fat" : type.description
        let bold = type == .cholesterol || type == .sodium
        
        if let value = nutrientAmount(for: type) {
            row(title: title,
                prefix: prefix,
                value: value,
                rdaValue: type.dailyValue?.0,
                unit: type.dailyValue?.1.shortDescription ?? "g",
                indentLevel: indentLevel,
                bold: bold,
                prefixedWithIncludes: prefixedWithIncludes
            )
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
    
    var carbRows: some View {
        Group {
            row(title: "Total Carbohydrate", value: carb, rdaValue: MacroRDA.carb, unit: "g", bold: true)
            nutrientRow(forType: .dietaryFiber, indentLevel: 1)
            nutrientRow(forType: .solubleFiber, indentLevel: 2)
            nutrientRow(forType: .insolubleFiber, indentLevel: 2)
            nutrientRow(forType: .sugars, indentLevel: 1)
            nutrientRow(forType: .addedSugars, indentLevel: 2, prefixedWithIncludes: true) /// Displays as "Includes xg Added Sugar"
            nutrientRow(forType: .sugarAlcohols, indentLevel: 2)
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
