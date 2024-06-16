//
// LCTO_14App.swift
// LCTO-14
// See DT/LCTO-14.txt

//  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
//  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

// DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
// Other Ap = pass to sim
// Record_Type = ProductComment
/*
 https://developer.apple.com/forums/thread/750845
  . . . in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Deployment/Targeted_Device_Families/iOS_deployment_target/
                (me = iOS 16.2)
 
 SAMPLE progroms >>>
 https://github.com/apple/sample-cloudkit-sharing
 */

// SO try/ - according to https://chatgpt.com/c/e169c3d8-c57b-4a51-bdef-6170294850d3 in
  // "If Using @EnvironmentObject" § toward the end.

// Xcode 14.2
import SwiftUI                                              // Already present in CV.swift

@main
struct LCTO_14App: App {
    var viewModel = ViewModel()                             // Create a ViewModel instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)               // Provides ViewModel as an environment object
        }
    }
}                                        // SEARCH FOR ->   5-24-24)1600  , = search obj wh has a comment

// //

