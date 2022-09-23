import SwiftUI
import SwiftHaptics
import PrepUnits

extension FoodLabel {
    class ViewModel<DataSource: FoodLabelDataSource>: ObservableObject {
        @Published var dataSource: DataSource
        
        init(dataSource: DataSource) {
            self.dataSource = dataSource
        }
    }
}

extension FoodLabel.ViewModel {
    var shouldShowMicronutrients: Bool {
        !dataSource.nutrients.filter { !$0.key.isIncludedInMainSection }.isEmpty
    }
    
    var shouldShowCustomMicronutrients: Bool {
        dataSource.haveCustomMicros
    }
    
    var showFooterText: Bool {
        dataSource.showFooterText
    }

    var showRDAValues: Bool {
        dataSource.showRDAValues
    }

    var amountString: String {
        dataSource.amountString
    }
    
    var energyAmount: Double {
        dataSource.energyAmount
    }
    var proteinAmount: Double {
        dataSource.proteinAmount
    }
    var carbAmount: Double {
        dataSource.carbAmount
    }
    var fatAmount: Double {
        dataSource.fatAmount
    }
    
    func nutrientAmount(for type: NutrientType) -> Double? {
        dataSource.nutrients[type]
//        dataSource.nutrient(ofType: type)
    }
}

public struct FoodLabel<DataSource: FoodLabelDataSource>: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject var viewModel: ViewModel<DataSource>

    @State var energyInCalories: Bool = true
    
    public init(dataSource: DataSource) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataSource: dataSource))
    }
    
    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            header
            calories
            Spacer().frame(height: 3)
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
    }
    public init() { }
}

extension FoodLabelPreview.ViewModel: FoodLabelDataSource {
    var haveMicros: Bool {
        true
    }
    
    var haveCustomMicros: Bool {
        false
    }
    
    var amountString: String {
        "1 serving"
    }
    
    var nutrients: [NutrientType : Double] {
        [
            .saturatedFat: 5
        ]
    }
    func nutrient(ofType type: NutrientType) -> Double? {
        switch type {
        case .saturatedFat:
            return 5
        default:
            return nil
        }
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
