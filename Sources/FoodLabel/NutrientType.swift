import PrepDataTypes

extension NutrientType {
    
    
    static var nutrientsIncludedInMainSection: [NutrientType] {
        [
            .saturatedFat,
            .polyunsaturatedFat,
            .monounsaturatedFat,
            .transFat,
            
            .cholesterol,
            .sodium,
            
            .dietaryFiber,
            .solubleFiber,
            .insolubleFiber,
            .sugars,
            .addedSugars,
            .sugarAlcohols
        ]
    }
    
    var isIncludedInMainSection: Bool {
        Self.nutrientsIncludedInMainSection.contains(self)
    }
}
