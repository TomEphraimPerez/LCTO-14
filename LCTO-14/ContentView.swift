//
// ContentView.swift
// LCTO-14
// See DT/LCTO-14.txt

// Created by thomasperez on 4/17/24.
// CV is UI
// "MODEL" is BUSINESS_LOGIC and DATA_MODEL

// CGPT -> Manual Environment Setup: In some complex scenarios or for testing,
  // directly pass viewModel as an observed object like this can be a temporary check:
  // @ObservedObject var viewModel = ViewModel()

import SwiftUI                                                       // Already present in LTCO_14App.swift
import Combine

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel                     // Make sure ViewModel is provided as an environment object
    //Manual Environment Setup: In some complex scenarios or for testing,
      // directly pass viewModel as an observed object like this can be a temporary check:
      // @ObservedObject var viewModel = ViewModel()
      // @ObservedObject var viewModel = ViewModel()
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()                           // Ensures the background covers all areas
            VStack {
                //Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                //Spacer()
                
                StarView(rating: viewModel.averageRating)           // Using StarView within ContentView. (Get er if using the binding "$")
                    .padding(.top)
                    
                
                
                
                                        // SEARCH     5-24-24)1600      // SEARCH                       // SEARCH
                
                //Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                // The $ is used in conjunction with property wrappers (previously known as "property delegates").
                // It's not an operator, but a prefix (thanks @matt!)
                // e.g. in    @State var aState = false,    then State is a property wrapper.
                // This means that if we write:
                //  aState we're accessing a Bool value
                //  $aState we're accessing a Binding<Bool> value
                //  --->>> It doesn't "make" a binding.         $aState IS THE INDING. – matt

                TextField("Search for the product here...", text: $viewModel.userInput3) //$ Binding text fld to VM's userInput. CGPT !
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)                                          // Disable automatic capitalization
                    .padding()
              
                Button("Search Product") {                                              // CGPT 5-24-24)1600 search obj wh has a comment
                    viewModel.fetchProductNames(searchTerm: viewModel.userInput3)
                                                            // Handle the fetched product names, e.g., update some state to display them
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                if !viewModel.searchMessage.isEmpty { // CONDITIONALLY DISP the text based on whether searchMessage is not empty. CGPT-5-31-24
                    Text(viewModel.searchMessage)     // Text view displaying searchMessage will automatically appear and disappear based on
                              // its content due to the reactive nature of the @PUBLISHED property and SwiftUI's automatic updating of views.
                    .foregroundColor(.red)
                    .padding()
                }
                
                                                            // Displaying search results
                if !viewModel.searchResults.isEmpty {
                                            // E@@@ SCROLLING @@@ SCROLLING    >>>---- --->>>>>>>
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.searchResults, id: \.self) { comment in   // Chg 'productName' to 'comment'
                                Text(comment)                                           // Chg 'productName' to 'comment'
                                    .padding()
                                    //.frame(maxWidth: .infinity, alignment: .leading)  // O
                                    //.frame(maxHeight: 250)                            // Try 5-31-24)1323 -> centered
                                    .background(Color.gray.opacity(0.3))                // Light gray background for each item
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
                    .border(Color.blue, width: 1)                       // Optional: adds a border around the search results area
                    .onReceive(viewModel.$searchResults) { _ in
                        print("\nSearch results updated: \(viewModel.searchResults)")
                    }
                                            // END @@@ SCROLLING @@@ SCROLLING    <<<<<<<---- <<<---
                    
        
                } else {
                    Text("\nNo results found")
                        .font(.headline)
                        //.padding()
                }
                //Spacer()                                              // Er= extra arg in call
             
                
             
                
                                    // POST                         // POST                         // POST
                
                TextField("Enter the product here...", text: $viewModel.userInput)      // .userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)                                          // Disable automatic capitalization
                    .padding()
                
                TextField("Enter your comment here...", text: $viewModel.userInput2)    // Binding the text field to the VM's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)  // Disable automatic capitalization
                    .padding()
                
                Button("Post Comment") {
                    let productName = viewModel.userInput       // .userInput2! This should be dynamic based on your app's needs
                    let comment = viewModel.userInput2
                    viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
            } // VStk
        } // ZStk
    } //var body
    
} // struct                                                         // SEARCH FOR ->   5-24-24)1600  , = search obj wh has a comment




//  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =|
                                    // STARS                        // STARS                       // STARS
                                    // Average # STARS to display
    
    //let imageFullStar = UIImage(systemName: "star.fill")
    //let imageHalfStar = UIImage(systemName: "star.leadinghalf.filled")
    //let imageHallowStar = UIImage(systemName: "star")
    //var body: some View {

struct StarView: View {
    @EnvironmentObject var viewModel: ViewModel
    var rating: Double  // Expected rating value between 0 and 5
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: starType(index: index))
                    .foregroundColor(.red)
            }
        }
        .onAppear{
            viewModel.calculateAverageRating(for: "Specific Product Name")
        }
        //.onReceive(Just(rating)) { newValue in
          //  print("\nRating updated to:\n \(newValue)")
    } // var body
    
    
    private func starType(index: Int) -> String {
        if Double(index) + 0.5 <= rating {
            return "star.fill"  // SF Symbol for fully filled star
        } else if Double(index) < rating {
            return "star.leadinghalf.fill"  // SF Symbol for half-filled star
        } else {
            return "star"  // SF Symbol for empty star
        }
    } // Pvt func starType
} // Free-standing struct StarView
//  =   =   =   =   =   =   =   =   =   =   =   =   =   END STARS   =   =   =   =   =   =   =   =   =   =   =   =   =   =|




// NON-SCROLLING --->>>
/*
List(viewModel.searchResults, id: \.self) { productName in
Text(productName)
}
.frame(maxHeight: 200)                                              // Ensures the list is not too tall
//.border(Color.blue, width: 1)  // Optional: adds a border around the search results area
// END NON-SCROLLING <<<---
*/

// @@@ SCROLLING @@@ SCROLLING    ---->>> --->>>>>>
// //
