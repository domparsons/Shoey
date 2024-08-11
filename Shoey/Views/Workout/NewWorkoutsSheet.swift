//
//  NewWorkoutsSheet.swift
//  Shoey
//
//  Created by Dom Parsons on 27/11/2023.
//

import SwiftUI
import SwiftData

struct NewWorkoutsSheet: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Shoe.shoeNickname, order: .forward) var shoes: [Shoe]
    
    @State var changesMade = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Add shoes to your recent workouts")
                        .font(.title3.bold())
                    Spacer()
                }
                
                ForEach(viewModel.newWorkouts) { workout in
                    HStack {
                        Image(systemName: "figure.run")
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.2f", workout.distance)) km run")
                            Text("\(workout.dateAndTime ?? Date(), formatter: AppDateFormatter.workoutFormatter)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        Menu {
                            ForEach(shoes) { shoe in
                                if shoe != workout.shoe && !shoe.retired {
                                    Button(shoe.shoeNickname) {
                                        changesMade = true
                                        viewModel.assignNewShoe(shoe: shoe, workout: workout)
                                    }
                                }
                            }
                            if workout.shoe != nil {
                                Button("No shoe") {
                                    viewModel.assignNoShoe(workout: workout)
                                }
                            }
                        } label: {
                            HStack {
                                Text(String(workout.shoe?.shoeNickname ?? ""))
                                workout.shoe != nil ? Image(systemName: "chevron.down") : Image(systemName: "plus")
                            }
                            
                        }
                        .onTapGesture {
                            if shoes == [] {
                                viewModel.showingNoShoesAlert = true
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button(changesMade ? "Save" : "Cancel") {
                        viewModel.newWorkoutsOnLoad = false
                    }
                }
            }
        }
    }
}

struct NewWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewContext = try! ModelContainer(for: Shoe.self, Workout.self).mainContext
        let viewModel = ViewModel(context: previewContext)

        NewWorkoutsSheet()
            .environmentObject(viewModel)
            .modelContainer(for: [Shoe.self, Workout.self])
    }
}
