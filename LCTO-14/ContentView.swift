

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            StarView(rating: viewModel.averageRating)
                //.padding(.top)                                                        // O
            
            TextField("Search for the product here...", text: $viewModel.userInput3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.padding()                                                            // O
                .autocapitalization(.none)

            Button("Search Product") {
                viewModel.fetchProductNames(searchTerm: viewModel.userInput3)
                viewModel.calculateAverageRating(for: viewModel.userInput3)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            if !viewModel.searchMessage.isEmpty {
                Text(viewModel.searchMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !viewModel.searchResults.isEmpty {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.searchResults, id: \.self) { comment in
                                Text(comment)
                                    //.padding()                                        // O. LKG 6-13-24
                                    .padding(.vertical, 4) // Reduced vertical padding
                                    .frame(height: 20) // Explicit height for each comment
                                    .background(Color.gray.opacity(0.3))                // Was 0.3
                                    .cornerRadius(2)                                    // Was 5.
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 2.15) // Using 66% of available height
                    .border(Color.blue, width: 2)                                           // Keep this fr prev <snippet>
                }
            } else {
                Text("No results found")
                    .font(.headline)
            }

            
            
            
            
            Spacer()                                    // O. Keep. Maintains spacing bt sections if there are no results.

            
            TextField("Enter the product here...", text: $viewModel.userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()                                              // O. Leave alone.
                .autocapitalization(.none)

        
            TextField("Enter star rating (0-5)", text: $viewModel.userInput4)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
            
            
            TextField("Enter your comment here...", text: $viewModel.userInput2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onChange(of: viewModel.userInput2) { newValue in
                        if newValue.count > 60 {                        // Adjust the max character limit as needed
                            viewModel.userInput2 = String(newValue.prefix(60))
                        }
                }
            
            
            Button("Post Comment") {
                viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2, rating: viewModel.userInput4)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct StarView: View {
    var rating: Double
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: starType(index: index))
                    .foregroundColor(index < Int(rating) ? .yellow : .gray)
            }
        }
    }
    
    private func starType(index: Int) -> String {
        if Double(index) < rating {
            return index + 1 <= Int(rating) ? "star.fill" : "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}
