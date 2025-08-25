//
//  MainUIView.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//

import SwiftUI
enum Tab: String, CaseIterable, Identifiable {
    case home = "Trang chủ"
    case borrow = "Danh sách mượn"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .borrow: return "list.bullet"
        }
    }
}
struct MainUIView: View {
    @State private var selectedTab: Tab = .home
    @State private var factorySelect: String = ""
    @Binding var userLogin: UserData?
    var body: some View {
        ZStack(alignment: .bottom) {
            // Nội dung chính
            TabView(selection: $selectedTab) {
                HomeUIView(factorySelect: $factorySelect, userLogin: $userLogin)
                    .tag(Tab.home)
                    .ignoresSafeArea(.all, edges: .bottom)
                
                ListBorrowUIView(userLogin: $userLogin,factorySelect: $factorySelect)
                    .tag(Tab.borrow)
                    .ignoresSafeArea(.all, edges: .bottom)
            }
            .padding(.bottom, 98)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            
            // Custom Tab Bar
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    TabButton(tab: tab, selectedTab: $selectedTab)
                    Spacer()
                }
            }
            .frame(height: 60)
            .background(Color.blue.cornerRadius(15))
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
//        .background(
//            Image("background")
//                .resizable()
//                .scaledToFill()
//        )
        
    }
}
struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.6))
                
                Text(tab.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.6))
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
    }
}
//#Preview {
//    MainUIView()
//}
