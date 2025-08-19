//
//  ListBorrowUIView.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//

import SwiftUI

struct ListBorrowUIView: View {
    @State private var searchText = ""
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    Text("DANH SÁCH CHO MƯỢN")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
                HStack {
                    SearchBar1(text: $searchText)
                }
                .padding(.horizontal)
            }
        }
    }
}
struct SearchBar1: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Nhập tên thiết bị cần tìm...", text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Huỷ")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
#Preview {
    ListBorrowUIView()
}
