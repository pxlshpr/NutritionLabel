import SwiftUI
import SwiftHaptics
import PrepUnits

extension FoodLabelDataSource {
    var shouldShowMicronutrients: Bool {
        !nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
    }
    
    var shouldShowCustomMicronutrients: Bool {
        //TODO: Fix this when custom micros are brought back
        false
    }
    
    var amountPerString: String {
        amountPerString
    }
    
    var energyAmount: Double {
        energyAmount
    }
    var proteinAmount: Double {
        proteinAmount
    }
    var carbAmount: Double {
        carbAmount
    }
    var fatAmount: Double {
        fatAmount
    }
    
    func nutrientAmount(for type: NutrientType) -> Double? {
        nutrients[type]
    }
}
//extension FoodLabel {
//    class ViewModel<DataSource: FoodLabelDataSource>: ObservableObject {
//        @Published var dataSource: DataSource
//
//        init(dataSource: DataSource) {
//            self.dataSource = dataSource
//        }
//    }
//}
//
//extension FoodLabel.ViewModel {
//    var shouldShowMicronutrients: Bool {
//        !dataSource.nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
//    }
//
//    var shouldShowCustomMicronutrients: Bool {
//        //TODO: Fix this when custom micros are brought back
//        false
//    }
//
//    var showFooterText: Bool {
//        dataSource.showFooterText
//    }
//
//    var showRDAValues: Bool {
//        dataSource.showRDAValues
//    }
//
//    var amountPerString: String {
//        dataSource.amountPerString
//    }
//
//    var energyAmount: Double {
//        dataSource.energyAmount
//    }
//    var proteinAmount: Double {
//        dataSource.proteinAmount
//    }
//    var carbAmount: Double {
//        dataSource.carbAmount
//    }
//    var fatAmount: Double {
//        dataSource.fatAmount
//    }
//
//    func nutrientAmount(for type: NutrientType) -> Double? {
//        dataSource.nutrients[type]
//    }
//}

//public struct FoodLabel<DataSource: FoodLabelDataSource>: View {
public struct FoodLabel<DataSource>: View where DataSource: FoodLabelDataSource {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var viewModel: DataSource

    init(dataSource: DataSource) {
        self.viewModel = dataSource
    }

    
    @State var energyInCalories: Bool = true
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            calories
            if viewModel.showRDAValues {
                Spacer().frame(height: 3)
            }
            macros
            if viewModel.shouldShowMicronutrients {
                macrosMicrosSeparator
                micros
            }
            if viewModel.shouldShowCustomMicronutrients {
                microsCustomSeparator
                customMicros
            }
            if viewModel.showFooterText {
                footer
            }
        }
        .padding(15)
        .border(borderColor, width: 5.0)
    }
}

public struct FoodLabelPreview: View {
    
    class ViewModel: ObservableObject {
        
    }

    @StateObject var viewModel = ViewModel()
    public var body: some View {
        FoodLabel(dataSource: viewModel)
            .frame(width: 350)
    }
    public init() { }
}

extension FoodLabelPreview.ViewModel: FoodLabelDataSource {
    var amountPerString: String {
        "1 serving (1 cup, chopped)"
    }
    
    var nutrients: [NutrientType : Double] {
        [
            .saturatedFat: 5,
            .addedSugars: 35
        ]
    }
    
    var showRDAValues: Bool {
        false
    }
    
    var showFooterText: Bool {
        false
    }
    
    var energyAmount: Double {
        235
    }
    
    var carbAmount: Double {
        45
    }
    
    var fatAmount: Double {
        8
    }
    
    var proteinAmount: Double {
        12
    }
}

struct FoodLabel_Previews: PreviewProvider {
    static var previews: some View {
        FoodLabelPreview()
    }
}
