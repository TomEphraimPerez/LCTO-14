//
//  ContentView.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var vm: ViewModel
    //try;
    @EnvironmentObject var viewModel: ViewModel
    //blw OK?
    //@ObservedObject var viewModel: ViewModel  // assuming ViewModel conforms to ObservableObject
    
    var body: some View {   // Place cursor under 'body' to code-fold to see better
         
                                        // ZStack
        ZStack{
            
            VStack() {                  // VStack
                                        // Ukr Blue
                Color(red: 0.0, green: 0.6, blue: 0.9) // sans .ignoresSafeArea()
       
                
                
                                        // HSTACK
                
                HStack{
                                        // Report button
                    Spacer()
                    
                    /*
                    Button {
                        Report()
                    } label: {
                        Image("2")
                    }
                    */
                    Button("Report") {
                        let productName = "Sample Product"
                        let comment = "Great product!"
                        viewModel.postComment(productName: productName, comment: comment)
                    }
                    
                    
                                        // Search button
                    Spacer()
                    
                    /*
                    Button {
                        Search()
                    } label: {
                        Image("3")
                    }
                    */
                    Button("Search") {
                        let productName = "Sample Product"
                        viewModel.fetchComments(for: productName) { comments in
                            // Update the UI to show fetched comments
                            print(comments)
                        }
                    }
                    
                    Spacer()
                }//H
                
                    
                
                                        // Ukr Yellow
                Color(red: 1.0, green: 1.0, blue: 0.0)//no.ignoresSafeArea()->no diff
                
                
                
                                        // Shelves display
                Image("1")
                    .resizable()
                    .padding(7.0)
                    .opacity(10.0)
                //.aspectRatio(contentMode: .fit)   // Can not pad Lt/Rt sides.
                    .cornerRadius(44.0)
                
                Text("Let's Check This OUT!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 9.0, green: 0.0, blue: 0.5))
                Spacer()
                
                                        // HStack
                HStack{
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                }
                .foregroundColor(.orange)
                
                
            }//VStack
        }//ZStack
    }//var body
    
    
    /*
    func Report(){
        print("Console out should have string 'Report'")
    }
    
    func Search(){
        print("Console out should have string 'Search'")
    }
    */
}//struct                                             // opt-sft </> fold/unfold




/*      ?   ?   ?
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

