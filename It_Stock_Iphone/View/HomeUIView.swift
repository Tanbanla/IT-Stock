//
//  HomeUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//

import SwiftUI

struct HomeUIView: View {
    @EnvironmentObject var userDataManager: UserDataManager
    @State private var isShowIcon: Bool = true
    @StateObject private var factoryVM = FactoryViewModel()
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
                HStack {
                    if isShowIcon{
                        Image("man")
                    } else{
                        Image("woman")
                    }
                    VStack(alignment: .leading){
//                        Text(userDataManager.currentUser?.nvchR_NAME ?? "Không xác định").font(.title2).bold().foregroundStyle(Color.blue)
//                        Text(userDataManager.currentUser?.chR_COST_CENTER ?? "Không xác định").font(.title3).bold().foregroundStyle(Color.blue)
                        Text("Không xác định").font(.title2).bold().foregroundStyle(Color.blue)
                        Text("Không xác định").font(.title3).bold().foregroundStyle(Color.blue)
                        Spacer()
                    }
                    Spacer()
                    Button{
                        
                    }label: {
                        HStack(spacing: 1) {
                            Text("Log Out").rotationEffect(.degrees(-90)).padding(.trailing, -20).font(.caption2)
                            Image("logout")
                        }
                    }
                }
                // lich
                
                //chọn kho
                HStack{
                    Text("Hãy chọn kho").bold().font(.system(size: 16)).foregroundStyle(Color.red)
                    VStack {
                        Image(systemName: "hand.tap").font(.system(size: 18)).foregroundStyle(Color.white).padding(3)
                    }.background(Color.red.opacity(0.8)).cornerRadius(20)
                    if factoryVM.isLoading {
                        ProgressView()
                            .frame(width: 100, height: 20)
                    } else {
//                        Picker("Chọn kho", selection: $factoryVM.selectedFactory) {
//                            ForEach(factoryVM.factories, id: \.self) { factory in
//                                Text(factory).tag(factory)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                        .frame(width: 150, height: 30)
//                        .background(Color.blue.opacity(0.8))
//                        .cornerRadius(20)
//                        .foregroundColor(.white)
                        Menu {
                            ForEach(factoryVM.factories, id: \.self) { factory in
                                Button {
                                    factoryVM.selectedFactory = factory
                                } label: {
                                    Text(factory)
                                }
                            }
                        } label: {
                            HStack {
                                Text(factoryVM.selectedFactory.isEmpty ? "Chọn kho" : factoryVM.selectedFactory).bold()
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }.frame(minWidth: 130)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(10).shadow(radius: 3)
                        }
                    }
                }
                // button
                
                Button{
                    
                }label: {
                    HStack{
                        Image("xuat").resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color.gray, lineWidth: 2)).padding()
                        VStack{
                            Text("XUẤT KHO - CHO MƯỢN").bold().font(.system(size: 13)).foregroundStyle(Color.blue).padding()
                        }.frame(minWidth: 180).background(Color.white).cornerRadius(20).padding(.trailing, 8)
                    }.frame(maxWidth: .infinity).background(Color.purple.opacity(0.3)).cornerRadius(20)
                }
                Button{
                    
                }label: {
                    HStack{
                        Image("nhap").resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color.gray, lineWidth: 2)).padding()
                        VStack{
                            Text("NHẬP KHO TÁI SỬ DỤNG").bold().font(.system(size: 13)).foregroundStyle(Color.blue).padding()
                        }.frame(minWidth: 180).background(Color.white).cornerRadius(20).padding(.trailing, 8)
                    }.frame(maxWidth: .infinity).background(Color.blue.opacity(0.3)).cornerRadius(20)
                }
                Button{
                    
                }label: {
                    HStack{
                        Image("scan_qr").resizable().frame(width: 60, height: 60).clipShape(Circle()).overlay(Circle().stroke(Color.gray, lineWidth: 2)).padding()
                        VStack{
                            Text("KIỂM KÊ").bold().font(.system(size: 13)).foregroundStyle(Color.blue).padding()
                        }.frame(minWidth: 180).background(Color.white).cornerRadius(20).padding(.trailing, 8)
                    }.frame(maxWidth: .infinity).background(Color.green.opacity(0.3)).cornerRadius(20)
                }
                
                
            }.padding(.leading,20).padding(.trailing, 20).onAppear {
//                if let section = userDataManager.currentUser?.chR_COST_CENTER {
//                    factoryVM.fetchFactories(section: section)
//                }
            }
        }
    }
}

#Preview {
    HomeUIView()
}
