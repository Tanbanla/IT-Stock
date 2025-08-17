//
//  UserDataManager.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//

import Foundation
import Combine
class UserDataManager: ObservableObject {
    @Published var currentUser: UserData?
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "currentUser") {
            currentUser = try? JSONDecoder().decode(UserData.self, from: data)
        }
    }
}
