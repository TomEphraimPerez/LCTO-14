//
//  ContentView.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack() {
            Color(red: 0.0, green: 0.69, blue: 0.6)
            Image("1")
                .resizable()
                .padding(9.0)
                .opacity(1.0)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(55.0)                             //non-op
            Text("Let's Check This Out")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
        }
        
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
