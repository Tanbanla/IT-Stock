//
//  UserDataManager.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//

import Foundation
import Combine
//class UserDataManager: ObservableObject {
//    @Published var currentUser: UserData?
//    
//    init() {
//        if let data = UserDefaults.standard.data(forKey: "currentUser") {
//            currentUser = try? JSONDecoder().decode(UserData.self, from: data)
//        }
//    }
//}
//class UserDataManager: ObservableObject {
//    @Published var currentUser: UserData?
//    @Published var isLoggedIn: Bool = false
//    
//    init() {
//        loadUserFromStorage()
//    }
//    
//    func loadUserFromStorage() {
//        if let data = UserDefaults.standard.data(forKey: "currentUser") {
//            do {
//                currentUser = try JSONDecoder().decode(UserData.self, from: data)
//                isLoggedIn = currentUser != nil
//                print("Loaded user from storage: \(currentUser != nil)")
//            } catch {
//                print("Error decoding user data: \(error)")
//                currentUser = nil
//                isLoggedIn = false
//                // Xóa dữ liệu corrupt
//                UserDefaults.standard.removeObject(forKey: "currentUser")
//            }
//        }
//    }
//    
//    func logout() {
//        currentUser = nil
//        isLoggedIn = false
//        
//        // Xóa cả các dữ liệu cache khác nếu có
//        UserDefaults.standard.removeObject(forKey: "currentUser")
//        UserDefaults.standard.removeObject(forKey: "token")
//        UserDefaults.standard.removeObject(forKey: "refreshToken")
//        UserDefaults.standard.synchronize()
//        
//        print("User logged out and data cleared")
//    }
//    
//    func saveUser(_ user: UserData) {
//        currentUser = user
//        isLoggedIn = true
//        
//        do {
//            let encoded = try JSONEncoder().encode(user)
//            UserDefaults.standard.set(encoded, forKey: "currentUser")
//            UserDefaults.standard.synchronize()
//            print("User saved to storage")
//        } catch {
//            print("Error saving user: \(error)")
//        }
//    }
//}
