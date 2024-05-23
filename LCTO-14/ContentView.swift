//
//  ContentView.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel  // Make sure ViewModel is provided as an environment object
    
    var body: some View {
        ZStack {
            VStack {
                Color(red: 0.0, green: 0.6, blue: 0.9).ignoresSafeArea()
                
                TextField("Enter your comment here...", text: $viewModel.userInput) // Binding the text field to the ViewModel's userInput
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Post Comment") {
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
    }
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
