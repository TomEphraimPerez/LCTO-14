/*
 CV.swift
 LCTO-14
 See DT/LCTO-14.txt

  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

 DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
 Other Ap = pass to sim
 Record_Type = ProductComment
*/
 
 
import SwiftUI


 struct ContentView: View {
     @EnvironmentObject var viewModel: ViewModel
     
     var body: some View {
         VStack {
             StarView(rating: viewModel.averageRating)
                 .padding(.top, -30)
             TextField("Search for the product here...", text: $viewModel.userInput3)
                 .frame(width: UIScreen.main.bounds.width * 0.82)                        // Set width to 92% of the screen width
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
                                     //.padding()                                            // O. LKG 6-13-24
                                     .padding(.vertical, 4)                                  // Reduced vertical padding
                                     .frame(height: 20)                                      // Explicit height for each comment
                                     .background(Color.gray.opacity(0.3))                    // Was 0.3
                                     .cornerRadius(2)                                        // Was 5.
                             }
                         }
                     }
                     .frame(width: geometry.size.width, height: geometry.size.height * 1.6) // Using 66% (2.15) of available ht
                     .border(Color.blue, width: 2)                                           // Keep this fr prev <snippet>
                 }
             } else {
                 Text("No results found")
                     .font(.headline)
             }

             
             Spacer()                                    // O. Keep. Maintains spacing bt sections if there are no results.

             
             TextField("Enter the product here...", text: $viewModel.userInput)
                 //.padding(.top, -10.0)                                                     // Was -10.0 (0.7 cm abv usrIP 4)
                 .frame(width: UIScreen.main.bounds.width * 0.82)                            // Set width to 92% of the screen width
                 //.padding([.top], UIScreen.main.bounds.height * 0.16)  // Adds padding top, shifting txt fld dwn 16% of the scn ht
                 //.padding(.top, UIScreen.main.bounds.height * 0.2) // Add 9% of scn ht as top padding. If >>, button lowers too much
                 .offset(y: UIScreen.main.bounds.height * 0.03) // Adjust this value to position userInput
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .autocapitalization(.none)

         
             TextField("Enter star rating (0-5)", text: $viewModel.userInput4)
                             .frame(width: UIScreen.main.bounds.width * 0.82)                // Set width to 92% of the screen width
                             .keyboardType(.numberPad)
                             .textFieldStyle(RoundedBorderTextFieldStyle())
                             .padding()
             
             
             TextField("Enter your comment here...", text: $viewModel.userInput2)
                 .frame(width: UIScreen.main.bounds.width * 0.92)                            // Set width to 92% of the screen width
                 .padding(.top, -30)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
                 .autocapitalization(.none)
                 .onChange(of: viewModel.userInput2) { newValue in
                         if newValue.count > 60 {                                            // Adjust the max character limit as needed
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
