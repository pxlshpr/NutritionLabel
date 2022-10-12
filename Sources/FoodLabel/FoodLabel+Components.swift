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
            if dataSource.showRDAValues {
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
//            Text(dataSource.amountString(withDetails: true, parentMultiplier: 1))
            Text(dataSource.amountPerString)
                .fontWeight(.bold)
                .font(.title3)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
                .lineLimit(3)
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
            labelCaloriesAmount
        }
        .if(dataSource.allowTapToChangeEnergyUnit, transform: { view in
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
        if dataSource.showRDAValues {
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
}
