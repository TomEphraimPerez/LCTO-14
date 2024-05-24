//
//  LCTO_14App.swift
//  LCTO-14
//
//  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
//  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:
/*
 https://developer.apple.com/forums/thread/750845
  . . . in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Deployment/Targeted_Device_Families/iOS_deployment_target/
                (me = iOS 16.2)
 
 SAMPLE progroms >>>
 https://github.com/apple/sample-cloudkit-sharing
 */

import SwiftUI

/* 5-15-24-)1507 TRY , via 2nd CGPT tab
 Yes, the modifications I suggested are intended to address the error you're encountering, which is caused by the absence of a required ViewModel instance in your environment when ContentView tries to access it. This error usually occurs because ContentView expects an EnvironmentObject of type ViewModel that hasn't been provided. Here’s a recap of how you can fix this issue in your LCTO_14App.swift and ensure ContentView has access to the ViewModel:

 If Using @EnvironmentObject
 You need to ensure that ContentView is wrapped with an .environmentObject() modifier that provides an instance of ViewModel. Here's how you can modify your LCTO_14App.swift:

 swift;;;
*/

/*
@main
struct LCTO_14App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/


 // SO TRY - according to https://chatgpt.com/c/e169c3d8-c57b-4a51-bdef-6170294850d3 in
   // "If Using @EnvironmentObject" § toward the end.
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
}



