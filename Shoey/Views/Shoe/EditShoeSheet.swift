//
//  EditShoeSheet.swift
//  Shoey
//
//  Created by Dom Parsons on 19/12/2023.
//

import SwiftUI

struct EditShoeSheet: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State var shoeNickname: String = ""
    @State var shoeModel: String = ""
    @State var colour: String = ""
    @State var currentMileage: Double? = nil
    @State var mileageLimit: Double = 400.0
    @State var selectedDistanceIndex = 0
    
    let distanceOptions = Array(stride(from: 400, through: 1200, by: 50))
    
    var shoe: Shoe
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Shoe details")) {
                        TextField("Nickname", text: $shoeNickname )
                        TextField("Model", text: $shoeModel)
                        TextField("Colourway", text: $colour)
                    }
                    
                    TextField("Current mileage", value: $currentMileage, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Section(header: Text("Shoe distance limit")) {
                        Picker("Distance Limit", selection: $selectedDistanceIndex) {
                            ForEach(distanceOptions.indices, id: \.self) { index in
                                Text("\(Int(distanceOptions[index])) km")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit shoe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let shoeWasEdited = editShoeDetails()
                        if shoeWasEdited {
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
        .onAppear() {
            
            let index = distanceOptions.firstIndex(where: { $0 == Int(shoe.mileageLimit) })
            
            shoeNickname = shoe.shoeNickname
            shoeModel = shoe.shoeModel
            colour = shoe.colour
            currentMileage = shoe.currentMileage
            mileageLimit = Double(distanceOptions[index ?? 0])
            selectedDistanceIndex = 0
        }
    }
    
    func editShoeDetails() -> Bool {
        guard validateInputs() else {
            viewModel.errorMessage = "Invalid shoe details"
            viewModel.showingError = true
            return false
        }

        shoe.shoeNickname = shoeNickname
        shoe.shoeModel = shoeModel
        shoe.colour = colour
        shoe.currentMileage = currentMileage ?? 0
        shoe.mileageLimit = Double(distanceOptions[selectedDistanceIndex])
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                viewModel.errorMessage = "An error occured when trying to edit shoe details."
                viewModel.showingError = true
            }
        }
        return true
    }
    
    func validateInputs() -> Bool {
        return !shoeNickname.isEmpty && !shoeModel.isEmpty && !colour.isEmpty && currentMileage ?? 0 >= 0
    }
}
//#Preview {
//    EditShoeSheet()
//}
