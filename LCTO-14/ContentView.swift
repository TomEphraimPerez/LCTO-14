//
//  ContentView.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24.
// CV is UI
// "MODEL" is BUSINESS_LOGIC and DATA_MODEL
// See LCTO-14.txt

import SwiftUI                                          // Already present in LTCO_14App.swift

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel         // Make sure ViewModel is provided as an environment object
    
    
/*
    var body: some View {                               // O but from Th 5-23-24)1815
        ZStack {
            VStack {
                Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Enter your comment here...", text: $viewModel.userInput) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Post Comment") {//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxXXXXXXXXXXXX
                    let productName = "Sample Product"  // This should be dynamic based on your app's needs
                    viewModel.postComment(productName: productName, comment: viewModel.userInput)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
            }
        }
    } //var body
*/
    var body: some View {
        ZStack {
            VStack {
                Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Enter your comment here...", text: $viewModel.userInput) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Enter the product here...", text: $viewModel.userInput2) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Post Comment") {                            //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxXXXXXXXXXXXX
                    let productName = viewModel.userInput           // This should be dynamic based on your app's needs
                    let comment = viewModel.userInput2
                    viewModel.postComment(productName: viewModel.userInput, comment: viewModel.userInput2)
                    
                    
                    //viewModel.postComment(comment: comment, viewModel.userInput2)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Spacer()
            }
        }
    } //var body

    
        
    
}

/*
@main
struct LCTO_14App: App {
    var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
*/
