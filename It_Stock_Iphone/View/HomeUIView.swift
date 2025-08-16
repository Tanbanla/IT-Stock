//
//  HomeUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//

import SwiftUI

struct HomeUIView: View {
    @State private var nameUser: String = "Hoang Ngoc Son"
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer()
                    Button{
                        
                    }label: {
                        HStack{
                            Image(systemName: "bell").resizable().frame(width: 28, height: 28).padding(12)
                        }
                        .background(Color.blue.opacity(0.2)).cornerRadius(20)
                    }
                }
                // thong tin user
                VStack(alignment: .leading){
                    Text(nameUser).font(.title2).bold().foregroundStyle(Color.blue)
                    
                }
            }.padding(.leading,20).padding(.trailing, 20)
        }
    }
}

#Preview {
    HomeUIView()
}
