//
// ContentView.swift
// LCTO-14
// See DT/LCTO-14.txt

// Created by thomasperez on 4/17/24.
// CV is UI
// "MODEL" is BUSINESS_LOGIC and DATA_MODEL

import SwiftUI                                                       // Already present in LTCO_14App.swift

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel                     // Make sure ViewModel is provided as an environment object

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()   // Ensures the background covers all areas
            VStack {
                
                //Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                //Spacer()

                
//  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =|
                                
                                
                            // STARS                        // STARS                       // STARS
                
                                                    // Average # STARS to display
                
                
                
//  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =|
                
                
                            // SEARCH     5-24-24)1600      // SEARCH                       // SEARCH
                
                
                //Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Search for the product here...", text: $viewModel.userInput3) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    Text(viewModel.searchMessage)
                    .foregroundColor(.red)
                    .padding()
                }
                
                                                                                        // Displaying search results
                if !viewModel.searchResults.isEmpty {
                    
                                            // NON-SCROLLING <<<---
                    /*
                    List(viewModel.searchResults, id: \.self) { productName in
                        Text(productName)
                    }
                    .frame(maxHeight: 200)                                              // Ensures the list is not too tall
                                            //.border(Color.blue, width: 1)  // Optional: adds a border around the search results area
                                            // END NON-SCROLLING <<<---
                    */
                    
                    
                                            // @@@ SCROLLING @@@ SCROLLING    ---->>> --->>>>>>
                                                                
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.searchResults, id: \.self) { productName in
                                Text(productName)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.3)) // Light gray background for each item
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .border(Color.blue, width: 1) // Optional: adds a border around the search results area
                    
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
             
                
             
//  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =|

                
                            // POST                         // POST                         // POST
                
                
                
                TextField("Enter the product here...", text: $viewModel.userInput)  // .userInput2 !
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Enter your comment here...", text: $viewModel.userInput2) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
    
} // struct                                                             // SEARCH FOR ->   5-24-24)1600  , = search obj wh has a comment

// //
