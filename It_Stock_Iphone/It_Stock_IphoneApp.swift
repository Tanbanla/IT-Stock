//
//  It_Stock_IphoneApp.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//

import SwiftUI

@main
struct It_Stock_IphoneApp: App {
    //@StateObject var userDataManager = UserDataManager()
    var body: some Scene {
        WindowGroup {
            LogInUIView()//.environmentObject(userDataManager)
        }
    }
}
