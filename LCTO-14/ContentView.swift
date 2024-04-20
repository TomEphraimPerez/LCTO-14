//
//  ContentView.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack{
        
            VStack() {
                //Ukr Blue
                Color(red: 0.0, green: 0.6, blue: 0.9) // sans .ignoresSafeArea()
                
                // HSTACK
                HStack{
                    // Report button
                    Spacer()
                    Image("2")
                        //.resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.padding(9.0)
                        //.frame(width: 200, height: 100)
                    
                    
                    // Search button
                    Spacer()
                    Image("3")
                        //.resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.padding(9.0)
                        //.frame(width: 210, height: 110)
                    Spacer()
                }//H
            
                
                //Ukr Yellow
                Color(red: 1.0, green: 1.0, blue: 0.0)//no.ignoresSafeArea()->no diff
                
                
                // Shelves display
                Image("1")
                    .resizable()
                    .padding(7.0)
                    .opacity(10.0)
                //.aspectRatio(contentMode: .fit)   // Can not pad Lt/Rt sides.
                    .cornerRadius(44.0)
                Text("Let's Check This OUT!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                
                
            }//VStack
        }//ZStack
    }//var body
    
}//struct                                             // opt-sft </> fold/unfold



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


