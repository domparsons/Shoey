//
//  NewShoeSheet.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import SwiftUI

struct NewShoeSheet: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.modelContext) var context
    
     
    @Environment(\.dismiss) var dismiss
    
    @State var shoeNickname: String = ""
    @State var shoeModel: String = ""
    @State var colour: String = ""
    @State var currentMileage: Double? = nil
    @State var mileageLimit: Double = 400.0
    @State var selectedDistanceIndex = 0
    
    let distanceOptions = Array(stride(from: 400, through: 1200, by: 50))
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Shoe details")) {
                        TextField("Nickname", text: $shoeNickname )
                        TextField("Model", text: $shoeModel)
                        TextField("Colourway", text: $colour)
                    }
                    
                    Section(header: Text("Shoe distance limit"), footer: Text("You can change this later.")) {
                        Picker("Distance Limit", selection: $selectedDistanceIndex) {
                            ForEach(distanceOptions.indices, id: \.self) { index in
                                Text("\(Int(distanceOptions[index])) km")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add shoe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let shoeWasSaved = saveNewShoe()
                        if shoeWasSaved {
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("An error occurred", isPresented: $viewModel.showingError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    func saveNewShoe() -> Bool {
        guard validateInputs() else {
            viewModel.errorMessage = "Invalid shoe details"
            viewModel.showingError = true
            return false
        }

        let shoe = Shoe(
            shoeNickname: shoeNickname,
            shoeModel: shoeModel,
            colour: colour,
            currentMileage: currentMileage ?? 0,
            mileageLimit: Double(distanceOptions[selectedDistanceIndex]),
            retired: false,
            workouts: []
        )
        
        self.context.insert(shoe)
        resetInputs()
        
        return true
    }
    
    func validateInputs() -> Bool {
        return !shoeNickname.isEmpty && !shoeModel.isEmpty && !colour.isEmpty && currentMileage ?? 0 >= 0
    }

    func resetInputs() {
        shoeNickname = ""
        shoeModel = ""
        colour = ""
        currentMileage = nil
        mileageLimit = 400
    }
}

#Preview {
    NewShoeSheet()
}
