/*
 Sun 6-16-24)1453
 Test for bug in github ""LKGgit add . All txtfld & button positions OK! TODO Scroll ht too tall""
  Could be excalmation points?? When committing _
   git commit -m "LKG!! All txtfld & button positions OK! TODO Scroll ht too tall"
  OR, could be terminal???
  
 
 CV.swift
 LCTO-14
 See DT/LCTO-14.txt

  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

 DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
 Other Ap = pass to sim
 Record_Type = ProductComment
    Can't use exclamation points on comments

*/

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            StarView(rating: viewModel.averageRating)
                .padding(.top, -30)

            ZStack {
                                                                                        // Placing the background under the rest of the UI
                Image("shelves")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.2)                                                       // Set the opacity to 0.2
                    .edgesIgnoringSafeArea(.all)                                        // Makes image fill the entire available space

                
                
                                                            // S E A R C H

                VStack {
                    TextField("Search for the product here...", text: $viewModel.userInput3)
                        .frame(width: UIScreen.main.bounds.width * 0.82)                // Set width to 82% of the screen width
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                                            .padding(.vertical, 4)                      // Reduced vertical padding
                                            .frame(height: 20)                          // Explicit height for each comment
                                            .background(Color.gray.opacity(0.3))        // Was 0.3
                                            .cornerRadius(2)                            // Was 5.
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height * 2.5) // O=1.6->using 66% of available ht
                                .border(Color.blue, width: 2)
                            }
                        }
                    } else {
                        Text("No results found")
                            .font(.headline)
                    }

                    Spacer()                                             // O. Keep. Maintains spacing bt sections if there are no results.

                    
                    
                                                            // P O S T
                    
                    TextField("Enter the product here...", text: $viewModel.userInput)
                        //.padding(.top, -10.0)                          // Was -10.0 (0.7 cm abv usrIP 4)
                        .frame(width: UIScreen.main.bounds.width * 0.82) // Set width to 82% of the screen width
                        //.padding([.top], UIScreen.main.bounds.height * 0.16)  // Adds padding top, shifting txt fld dwn 16% of the scn ht
                        //.padding(.top, UIScreen.main.bounds.height * 0.2)     // Add x% of scn ht as top padding. If >>, button lowers too much
                        .offset(y: UIScreen.main.bounds.height * 0.03)   // Adjust this value to position userInput
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    
                    TextField("Enter star rating (0-5)", text: $viewModel.userInput4)
                        .frame(width: UIScreen.main.bounds.width * 0.82)                // Set width to 82% of the screen width
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    
                    TextField("Enter your comment here...", text: $viewModel.userInput2)
                        .frame(width: UIScreen.main.bounds.width * 0.92)
                        .padding(.top, -30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)
                        .onChange(of: viewModel.userInput2) { newValue in
                            if newValue.count > 60 {                                    // Adjust the max character limit as needed
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
            }
        }
        .padding()
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
