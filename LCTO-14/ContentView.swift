
// DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
// Other Ap = pass to sim

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var comment: String = ""
    private let maxCharacters = 100                             // Set the maximum number of characters allowed
    
    var body: some View {
        VStack {
                                                                // Displaying the star ratings at the top
            StarView(rating: viewModel.averageRating)
                .padding(.top)
            
                                                                // SEARCH
            
            TextField("Search for the product here...", text: $viewModel.userInput3)    // "$" !
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

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
            
            
                                                                // Display search results or a placeholder message
            if !viewModel.searchResults.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.searchResults, id: \.self) { comment in
                            Text(comment)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 120)
                .border(Color.blue, width: 1)
            } else {
                Text("No results found")
                    .font(.headline)
                    .padding()
            }

            
                                                                // POST
            
            TextField("Enter the product here...", text: $viewModel.userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
            
            
            /*
            TextField("Enter your comment here...", text: $viewModel.userInput2)    // O and working 6-10-24)1651
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
             */
            TextField("Enter your comment here...", text: $viewModel.userInput2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onChange(of: viewModel.userInput2) { newValue in
                    if newValue.count > maxCharacters {
                        viewModel.userInput2 = String(newValue.prefix(maxCharacters))
                    }
                }
            
            
            Text("\(comment.count)/\(maxCharacters) characters")                    // Char counter
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            

            Button("Post Comment") {
                viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

                                                                // STARS
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
