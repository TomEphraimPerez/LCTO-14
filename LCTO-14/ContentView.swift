//
// Copyright © 2024 bundle LCTO -14
/*
 VM.swift
 LCTO-14
 See DT/LCTO-14.txt

  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

 DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
 Other Ap = pass to sim
 Record_Type = ProductComment
 Can't use exclamation points on comments

*/

                                                                    // IMAGES BRA
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    private let maxCharacters = 88

    var body: some View {
        VStack(spacing: 20) {
            StarView(rating: viewModel.averageRating)
                .padding(.top, -15) // Adjust padding as needed
            
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Search for the product here...", text: $viewModel.userInput3)
                        .padding(.top, 0.5)
                        .frame(width: UIScreen.main.bounds.width * 0.82)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
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
                            .bold()
                    }
                    
                    if !viewModel.searchResults.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.searchResults, id: \.self) { comment in
                                Text(comment)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    } else {
                        Text("No results found")
                            .font(.headline)
                    }
                    
                    Spacer()

                    VStack(spacing: 10) {
                        TextField("Enter the product here...", text: $viewModel.userInput)
                            .frame(width: UIScreen.main.bounds.width * 0.82)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Enter star rating (0-5)", text: $viewModel.userInput4)
                            .frame(width: UIScreen.main.bounds.width * 0.82)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        TextField("Enter your comment here...", text: $viewModel.userInput2)
                            .frame(width: UIScreen.main.bounds.width * 0.92)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: viewModel.userInput2) { newValue in
                                if newValue.count > maxCharacters {
                                    viewModel.userInput2 = String(newValue.prefix(maxCharacters))
                                }
                            }

                        Text("\(viewModel.userInput2.count)/\(maxCharacters) characters")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2, rating: viewModel.userInput4)
                        }) {
                            Text("Post Comment")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // Image buttons
                        Button(action: {
                            viewModel.pickImage(isBeforeImage: true)
                        }) {
                            Text("Pick Before Image")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.pickImage(isBeforeImage: false)
                        }) {
                            Text("Pick After Image")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // Display selected images
                        if let beforeImage = viewModel.beforeImage {
                            Image(uiImage: beforeImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        }
                        
                        if let afterImage = viewModel.afterImage {
                            Image(uiImage: afterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Image("shelves").resizable().aspectRatio(contentMode: .fill).opacity(0.4).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}






