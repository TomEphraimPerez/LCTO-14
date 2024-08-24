
// Copyright © 2024 bundle LCTO -14
/*
 VM.swift
 LCTO-14
 See DT/LCTO-14.txt

  Created by thomasperez on 4/17/24. | Swift 5. in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Swift_compiler_Lang/..ver
  For future customer updates/downloads fr AppStore, check their OS version vs my deployment target:

 DEVELOPED BY THOMAS EPHRAIM PEREZ APRIL 2024
 Other Ap = pass to sim
 Record_Type = ProductComment
 Can't use exclamation points on comments

*/
/*
 https://developer.apple.com/forums/thread/750845
  . . . in toplevel LCTO-14 /LCTO-14.xcodeproj/Build_settings/Deployment/Targeted_Device_Families/iOS_deployment_target/
                (me = iOS 16.2)
 
 SAMPLE progroms >>>
 https://github.com/apple/sample-cloudkit-sharing
 */

// SO try/ - according to https://chatgpt.com/c/e169c3d8-c57b-4a51-bdef-6170294850d3 in
  // "If Using @EnvironmentObject" § toward the end.


// Xcode 14.2 -> 14.5 (JULY)




//                                      TO RUN IN TERMINAL, EG., FOR THE IMAGES BRANCH (connect iPhone via USB)
//                                      TO RUN IN TERMINAL, EG., FOR THE IMAGES BRANCH
//($ xcode-select --install )                    // A KMUST, FOR RUNNING CMD LINE build, XC-install and XC-launch
//($ xcrun simctl list devices †† )
//($ instruments -s devices )                   // confirm the device (inc correct UUID) is actually connected. Also see all avail devices. Non-op.
//
//              BUILD                   BUILD
//$$$ xcodebuild -scheme "LCTO-14" -destination 'id=00008030-000608D90E9A402E' build       // id via XC/Window/Devices-and-Simulators ††
//$$$ xcodebuild -scheme "LCTO-14" -destination 'id=00008030-000608D90E9A402E' build
//
//
//              INSTALL                 INSTALL
//
// Below CMD does NOT DOWNLOAD APP ONTO iPHONE, ANYWHERE •••
//$$$ xcodebuild -scheme "LCTO-14" -destination 'id=00008030-000608D90E9A402E' -configuration Release install           †††
//$$$ xcodebuild -scheme "LCTO-14" -destination 'id=00008030-000608D90E9A402E' -configuration Release install
//                          : )     WORKS 8-23-24)1326      : )  Terminal >>> " INSTALL SUCCEEDED "
//                                                                       •••  ...bUT NO APP INSTALLED. ALSO NOT in iPhone/Settings/General/iPhone-Storage
//
//
//              LAUNCH                  INSTALL

/*              LAUNCH alternate >>>  (NON-OP)              NON-OP              NON-OP                  NON-OP                      NON-OP
                    C-GPT-omni >>>If you want to LAUNCH the app automatically from the command line after installation, you can use the following command:
 xcrun xctrace run --target '00008030-000608D90E9A402E' --launch --app "com.tomEphraimPerez.LCTO-14"
        Terminal >>> ' "run" is no recognized'
        CGPT     >>> The correct way to launch an app on a physical device after installation typically involves interacting with the app directly on the device
                     ((or using Xcode's interface)).
               SO: After the app is installed using xcodebuild †††, unlock your iPhone and find the app icon on your home screen.
                     Tap the icon to              *** launch the app manually ***.
       NON-OP           NON-OP          NON-OP                                  NON-OP                      NON-OP                      NON-OP
 */



//$ git add .
//$ git commit -m "Added image feature"
//$ git push origin Images



/* RESULTS WHEN USING a UUID slightly different than 00008030-000608D90E9A402E
 --- xcodebuild: WARNING: Using the first of multiple matching destinations:
 { platform:iOS, arch:arm64, id:00008030-000608D90E9A402E, name:Thomas’s iPhone }
 */
import SwiftUI                                              // Already present in CV.swift
import Foundation

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

