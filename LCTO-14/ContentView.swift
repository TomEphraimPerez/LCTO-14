//
//  ContentView.swift
//  LCTO-14
// See LCTO-14.txt

//  Created by thomasperez on 4/17/24.
// CV is UI
// "MODEL" is BUSINESS_LOGIC and DATA_MODEL


import SwiftUI                                          // Already present in LTCO_14App.swift

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel         // Make sure ViewModel is provided as an environment object

    var body: some View {
        ZStack {
            VStack {
                                    // POST                 // POST                 // POST
                
                Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Enter the product here...", text: $viewModel.userInput) // .userInput2 !
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
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
                
                
                //  =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =   =|
                
                
                                    // SEARCH            5-23-24)1925   // SEARCH               // SEARCH
                
                Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Search for the product here...", text: $viewModel.userInput3) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                /*
                TextField("Take picture for search here...", text: $viewModel.userInpu4) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                */
                
                
                
                /*                                      HAD TO ASK CGPT 5-24-24)1511
                Button("Search Product") {
                    //XXX let productName = viewModel.userInput3 //This s/b dynamic based ur app's needs. !X!X ur re-defining prodNam see li32!
                /*
                    let comment = viewModel.userInput4                                  // Reserve for pix
                */                                                                      // reefinition ??
                    let productName = viewModel.userInput3
                    // viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2)   >>>
                    viewModel.fetchProductNames(productName: viewModel.userInput3)                                          // <<< XXXXXXXXX
                }
                */
                //                                              >>>
                Button("Search Product") {                                              // CGPT 5-24-24)1520
                    viewModel.fetchProductNames(searchTerm: viewModel.userInput3) { productNames in
                        // Handle the fetched product names, e.g., update some state to display them
                        print(productNames)
                    }
                }

                
                
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
                
                
                
            } // VStk
        } // ZStk
    } //var body
    
}


