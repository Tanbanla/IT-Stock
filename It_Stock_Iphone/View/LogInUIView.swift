//
//  LogInUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//

import SwiftUI

struct LogInUIView: View {
    @StateObject private var loginController = LoginController()
    @State private var adid: String = ""
    @State private var password: String  = ""
    @State private var showEye: Bool = true
    var body: some View {
            VStack{
                // view top
                Text("Welcome To").font(.title3).bold().foregroundStyle(Color.blue.opacity(0.7)).padding()
                Text("IT STOCK MANAGEMENT SYSTEM").font(.title2).bold().foregroundStyle(Color.blue)
                HStack(spacing: 4){
                    HStack{
                    }.frame(width: 90, height: 2).background(Color.blue)
                    HStack(spacing: -1){
                        Image(systemName: "star.circle").foregroundStyle(Color.blue)
                        Image(systemName: "star.circle").foregroundStyle(Color.blue)
                    }
                    Image(systemName: "star.circle").resizable().frame(width: 28, height: 28).foregroundStyle(Color.blue)
                    HStack(spacing: -1){
                        Image(systemName: "star.circle").foregroundStyle(Color.blue)
                        Image(systemName: "star.circle").foregroundStyle(Color.blue)
                    }
                    HStack{
                    }.frame(width: 90, height: 2).background(Color.blue)
                }
                // view middle
                VStack(alignment: .leading, spacing: 4){
                    HStack {
                        Text("ADID").bold().font(.title2).foregroundStyle(Color.blue)
                        Spacer()
                    }
                    HStack{
                        TextField("Nhập Adid", text: $adid).onChange(of: adid) { newValue in
                            let uppercasedValue = newValue.lowercased()
                            adid = uppercasedValue
                            
                        }.frame(height: 60).padding(.leading, 10).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray,lineWidth:1.0))
                    }
                }.padding(.leading, 30).padding(.trailing, 30).padding(.bottom)
                VStack(alignment: .leading, spacing: 4){
                    HStack {
                        Text("Mật khẩu").bold().font(.title2).foregroundStyle(Color.blue)
                        Spacer()
                    }
                    HStack{
                        HStack{
                            if showEye{
                                SecureField("Nhập mật khẩu", text: $password)
                            }else{
                                TextField("Nhập mật khẩu", text: $password)
                            }
                            Button{
                                withAnimation{
                                    showEye.toggle()
                                }
                            }label: {
                                Image(systemName: showEye ? "eye.slash" : "eye").resizable().frame(width: 26, height:20).padding(.trailing,8).foregroundStyle(Color.gray)
                            }
                        }.frame(height: 60).padding(.leading, 10).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray,lineWidth:1.0))
                    }
                }.padding(.leading, 30).padding(.trailing, 30)
                
                // view bottom
                Button{
                    loginController.login(adid: adid, password: password) { success in
                        if success {
                            // Xử lý sau khi đăng nhập thành công
                            print("Đăng nhập thành công: \(loginController.userData?.nvchR_NAME ?? "")")
                        }
                    }
                }label: {
                    HStack{
                        if loginController.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Đăng nhập")
                                .bold()
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }.frame(maxWidth: .infinity).frame(height: 50).background(Color.blue).cornerRadius(12).padding(.leading,30).padding(.trailing,30).padding(.top,20)
                }
                Spacer()
                Image("logo_company").resizable().frame(width: 300, height: 130)
            }.alert(isPresented: $loginController.isLoggedIn) {
                Alert(
                    title: Text("Đăng nhập thành công"),
                    message: Text("Xin chào \(loginController.userData?.nvchR_NAME ?? "")"),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

#Preview {
    LogInUIView()
}
