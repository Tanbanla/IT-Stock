//
//  NhapKhoUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

import SwiftUI

struct NhapKhoUIView: View {
    let selectKho: String
    let section: String
    let adid: String
    @StateObject private var masterGoodVM = MasterGoodViewModel()
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @State var currentDate:  String = ""
    @State private var formattedDate: String = ""
    @State private var phanLoai:  String = ""
    @State private var soLuong:  String = ""
    @State private var lyDo:  String = ""
    @State private var showScran:  Bool =  false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill").resizable().frame(width: 24, height: 24).foregroundStyle(Color.blue)
                    }.shadow(radius: 3)
                    Spacer()
                    Text("Nhập hàng tái sử dụng").bold().font(.title2).foregroundStyle(Color.blue)
                    Spacer()
                }
                ScrollView {
                    VStack(spacing: 20) {
                        // Phân loại
                        HStack(alignment: .top, spacing: 12) {
                            Text("Phân loại")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .frame(width: 90, alignment: .leading)
                            
                            Text(phanLoai)
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
                                masterGoodVM.getMasterByCode(stockName: selectKho, code: code)
                                phanLoai = masterGoodVM.data?.nvchR_ITEM_NAME ?? ""
                            }
                        }
                        
                        // Kho nhập
                        HStack(alignment: .top, spacing: 12) {
                            Text("Kho nhập")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .frame(width: 90, alignment: .leading)
                            
                            Text(selectKho)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Số lượng
                        HStack(alignment: .top, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("Số lượng")
                                    .font(.headline)
                                    .foregroundStyle(Color.blue)
                                Text("*")
                                    .font(.headline)
                                    .foregroundStyle(Color.red)
                            }
                            .frame(width: 90, alignment: .leading)
                            
                            TextField("Nhập số lượng", text: $soLuong)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                        }
                        
                        // Ngày nhập
                        HStack(alignment: .top, spacing: 12) {
                            Text("Ngày nhập")
                                .font(.headline)
                                .foregroundStyle(Color.blue)
                                .frame(width: 90, alignment: .leading)
                            
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
                                )
                        }
                        //button
                        Button{
                            submitImport()
                        }label: {
                            HStack{
                                Text("NHẬP KHO")
                                    .font(.system(size: 16)).bold().foregroundColor(.white).padding()//.bold()
                            }.frame(maxWidth: 240).frame(height: 40).background(Color.blue.opacity(0.6)).cornerRadius(8).padding()
                        }
                    }
                }
                Spacer()
            }.padding(.horizontal, 20).alert("Thành công", isPresented: $masterGoodVM.isSuccess) {
                Button("OK") {
                    resetForm()
                }
            } message: {
                Text("Nhập kho thành công")
            }
            .alert("Lỗi", isPresented: .constant(masterGoodVM.errorMessage != nil), actions: {
                Button("OK") {
                    masterGoodVM.errorMessage = nil
                }
            }, message: {
                Text(masterGoodVM.errorMessage ?? "")
            })
        }.background(
            Image("background")
                .resizable()
                .scaledToFill()
        )
    }
    private func submitImport() {
            
           guard let quantity = Int(soLuong) else {
               masterGoodVM.errorMessage = "Số lượng phải là số nguyên"
               return
           }
        // Hàm chuyển đổi String -> Date
        func convertStringToDate(dateString: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            return dateFormatter.date(from: dateString)
        }
        
        // Sử dụng
        if let date = convertStringToDate(dateString: currentDate) {
            let request = ImportUsedGoodsRequest(
                itemName: phanLoai,
                warehouse: selectKho,
                quantity: quantity,
                date: date, // Sử dụng kiểu Date
                userId: adid,
                reason: lyDo
            )
            masterGoodVM.importUsedGoods(request: request) { success in
                   if success {
                       resetForm()
                   }
               }
        } else {
            masterGoodVM.errorMessage = "Lỗi: Không thể chuyển đổi ngày tháng"
            return
        }
       }
       
       private func resetForm() {
           phanLoai = ""
           soLuong = ""
           lyDo = ""
       }
}

#Preview {
    NhapKhoUIView(selectKho: "Kho IT", section: "3510",adid: "khanhmf")
}
