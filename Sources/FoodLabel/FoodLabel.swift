import SwiftUI
import SwiftHaptics
import PrepUnits
import FoodLabelScanner

public struct FoodLabel<DataSource>: View where DataSource: FoodLabelDataSource {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var dataSource: DataSource

    @State var showingEnergyInCalories: Bool

    public init(dataSource: DataSource) {
        self.dataSource = dataSource
        _showingEnergyInCalories = State(initialValue: dataSource.energyValue.unit != FoodLabelUnit.kj)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            calories
            if dataSource.showRDAValues {
                Spacer().frame(height: 3)
            }
            macros
            if dataSource.shouldShowMicronutrients {
                macrosMicrosSeparator
                micros
            }
            if dataSource.shouldShowCustomMicronutrients {
                microsCustomSeparator
                customMicros
            }
            if dataSource.showFooterText {
                footer
            }
        }
        .padding(15)
        .border(borderColor, width: 5.0)
        .onChange(of: dataSource.energyValue) { newValue in
            if newValue.unit == .kj && showingEnergyInCalories {
                withAnimation {
                    showingEnergyInCalories = false
                }
            }
        }
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
    
    var energyValue: FoodLabelValue {
        FoodLabelValue(amount: 235, unit: .kj)
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
