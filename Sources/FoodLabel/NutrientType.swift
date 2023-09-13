import PrepShared

extension Micro {
    
    
    static var nutrientsIncludedInMainSection: [Micro] {
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
