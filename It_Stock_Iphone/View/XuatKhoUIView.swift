//
//  XuatKhoUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

import SwiftUI

struct XuatKhoUIView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @StateObject private var xuatKhoVM = XuatKhoViewModel()
    @EnvironmentObject var userDataManager: UserDataManager
    @State var currentDate:  String = ""
    @State private var formattedDate: String = ""
    @State private var lyDo:  String = ""
    @State private var showScran:  Bool =  false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill").resizable().frame(width: 24, height: 24).foregroundStyle(Color.blue)
                    }.shadow(radius: 3)
                    Spacer()
                    Text("Xuất kho - Cho mượn").bold().font(.title2).foregroundStyle(Color.blue)
                    Spacer()
                }
                ScrollView{
                    VStack(spacing: 20){
                        // Phân loại xuất
                        HStack(alignment: .top, spacing: 6) {
                            Text("Phân loại xuất")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                            
                            Menu {
                                ForEach(xuatKhoVM.listLuaChon, id: \.self) { loaiXuat in
                                    Button {
                                        xuatKhoVM.loai = loaiXuat
                                    } label: {
                                        Text(loaiXuat)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(xuatKhoVM.loai.isEmpty ? "Chọn kho" : xuatKhoVM.loai).bold()
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.blue)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        // Phân loại
                        HStack(alignment: .top, spacing: 12) {
                            Text("Phân loại")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .frame(width: 105, alignment: .leading)
                            
                            Text(xuatKhoVM.phanLoai)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            Button {
                                withAnimation{
                                    showScran = true
                                }
                            } label: {
                                Image(systemName: "camera.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Color.blue.opacity(0.6))
                            }
                        }.sheet(isPresented: $showScran) {
                            BarcodeScannerView(viewModel: viewModel) { code in
                                
                            }
                        }
                        // kho nhận
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("Kho nhận")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 105, alignment: .leading)
                            Menu {
                                if let listStock = xuatKhoVM.ListStock {
                                    ForEach(listStock, id: \.self) { khoNhan in
                                        Button {
                                            xuatKhoVM.khoNhan = khoNhan
                                        } label: {
                                            Text(khoNhan.chR_FACTORY ?? "Không có tên") // Hiển thị tên kho
                                        }
                                    }
                                } else {
                                    // Hiển thị khi đang loading hoặc không có data
                                    if xuatKhoVM.isLoading {
                                        ProgressView()
                                    } else {
                                        Text("Không có dữ liệu kho")
                                            .foregroundColor(.gray)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(xuatKhoVM.LoaiHang.isEmpty ? "Chọn kho nhận" : xuatKhoVM.LoaiHang).bold()
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.blue)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }.onAppear{
                            xuatKhoVM.getListFactory(section: "3510")
                            //userDataManager.currentUser?.chR_COST_CENTER
                        }
                        // loại hàng
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("Loại hàng")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 105, alignment: .leading)
                            Menu {
                                ForEach(xuatKhoVM.ListLoaiHang, id: \.self) { loaiHang in
                                    Button {
                                        xuatKhoVM.LoaiHang = loaiHang
                                    } label: {
                                        Text(loaiHang)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(xuatKhoVM.LoaiHang.isEmpty ? "Chọn loại hàng" : xuatKhoVM.LoaiHang).bold()
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.blue)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        // Số lượng tồn
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("SL Tồn")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                            }
                            .frame(width: 105, alignment: .leading)
                            Text("")
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        // Số lượng xuất
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("SL Xuất")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 105, alignment: .leading)
                            Text("")
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        // Ngày xuất
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4){
                                Text("Ngày xuất")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }.frame(width: 105, alignment: .leading)
                            Text(currentDate)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .onAppear {
                                    let date = Date()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MM/yyyy"
                                    currentDate = formatter.string(from: date)
                                }
                        }
                        // Ngày trả
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4){
                                Text("Ngày dự trả")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }.frame(width: 105, alignment: .leading)
                            Text(currentDate)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .onAppear {
                                    let date = Date()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MM/yyyy"
                                    currentDate = formatter.string(from: date)
                                }
                        }
                        // Mã nhân viên
                        HStack(alignment: .top, spacing: 12) {
                            Text("Mã NV")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .frame(width: 105, alignment: .leading)
                            
                            Text(xuatKhoVM.MaNv)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            Button {
                                withAnimation{
                                    showScran = true
                                }
                            } label: {
                                Image(systemName: "camera.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Color.blue.opacity(0.6))
                            }
                        }.sheet(isPresented: $showScran) {
                            BarcodeScannerView(viewModel: viewModel) { code in
                                
                            }
                        }
                        // Tên NV
                        HStack(alignment: .top, spacing: 12) {
                            Text("Tên NV")
                                .font(.headline)
                                .foregroundStyle(Color.blue).frame(width: 105, alignment: .leading)
                            Text("")
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Số điện thoại liên hệ
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("Liên hệ")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 105, alignment: .leading)
                            Text("")
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Lý do
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("Lý do")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 90, alignment: .leading)
                            
                            TextEditor(text: $lyDo)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                ).onAppear{
                                    xuatKhoVM.LyDo = lyDo
                                }
                        }
                        
                        // Button
                        Button{
                            
                        }label: {
                            HStack{
                                Text("XÁC NHẬN")
                                    .font(.system(size: 16)).bold().foregroundColor(.white).padding()//.bold()
                            }.frame(maxWidth: .infinity).frame(height: 40).background(Color.blue.opacity(0.6)).cornerRadius(8)
                        }
                    }
                }
                
            }.padding(.horizontal).alert("Lỗi", isPresented: .constant(xuatKhoVM.errorMessage != nil)) {
                Button("OK") {
                    xuatKhoVM.errorMessage = nil
                }
            } message: {
                Text(xuatKhoVM.errorMessage ?? "")
            }
        }.background(
            Image("background")
                .resizable()
                .scaledToFill()
        )
    }
}

#Preview {
    XuatKhoUIView()
}
