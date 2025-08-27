//
//  TraTBUIView.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 20/8/25.
//

import SwiftUI

struct TraTBUIView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @StateObject private var xuatKhoVM = XuatKhoViewModel()
    @Binding var userLogin: UserData?
    @State private var currentDate: String = ""
    @State private var lyDo: String = ""
    
    @State private var showScran: Bool = false
    @State private var isLoading: Bool = false
    
    //thong tin thiet bi tra
    let item: ListBorrowData?
    let selectKho: String

    
    @Environment(\.dismiss) private var dismiss
//    let listKho: [FactoryData]?
//    let selectKho: String
    var body: some View {
        ZStack{
            VStack(spacing: 0){
              // header
                headerView
                ScrollView{
                    VStack(spacing: 20){
                        // Phân loại view
                        phanLoaiView
                        
                        // Loại hàng view
                        loaiHangSection
                        
                        // Số lượng trả
                        soLuongSection
                        
                        // Ngày trả
                        ngayThangSection
                        
                        //Mã nhân viên
                        nhanVienSection
                        
                        // Button
                        confirmButton
                    }
                }.padding(.horizontal, 20)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                )
            }
        }
        .alert("Lỗi", isPresented: .constant(xuatKhoVM.errorMessage != nil)) {
            Button("OK") {
                xuatKhoVM.errorMessage = nil
            }
        } message: {
            Text(xuatKhoVM.errorMessage ?? "")
        }
        .alert("Thành công", isPresented: $xuatKhoVM.isSuccess) {
            Button("OK") {
                xuatKhoVM.ResetFrom()
            }
        } message: {
            Text("Trả thiết bị thành công")
        }
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                showScran = false
                handleBarcodeScanned(code: code)
            }
        }
        .onAppear {
            setupInitialDate()
            setupInitialData()
        }
    }
    // MARK: - Setup Initial Data
       private func setupInitialData() {
           // Thiết lập dữ liệu ban đầu từ item
           xuatKhoVM.phanLoai = item?.nvchR_ITEM_NAME ?? ""
           xuatKhoVM.LoaiHang = item?.chR_TYPE_GOODS ?? ""
           
           if let qtyInStock = item?.inT_QTY_IN_STOCK {
               xuatKhoVM.slTon = String(qtyInStock)
           } else {
               xuatKhoVM.slTon = "0"
           }
       }
    // MARK: - Header View
    private var headerView: some View {
        HStack{
            Button{
                dismiss()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.blue)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            Spacer()
            Text("TRẢ THIẾT BỊ").font(.system(size: 18, weight: .bold)).foregroundStyle(.blue).padding(.leading, -44)
            Spacer()
        }.padding()
    }
    
    // MARK: - Phân Loại
    private var phanLoaiView: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("Phân Loại").font(.system(size: 16, weight: .semibold)).foregroundStyle(.blue)
            HStack(spacing: 12){
                TextField("Mã sản phẩm", text: $xuatKhoVM.phanLoai)
                    .disabled(true)
                    .padding(.horizontal,16)
                    .padding(.vertical,14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Loại Hàng Section
    private var loaiHangSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Loại hàng")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            HStack {
                Text(xuatKhoVM.LoaiHang.isEmpty ? "Chọn loại hàng" : xuatKhoVM.LoaiHang)
                    .font(.system(size: 16))
                    .foregroundColor(xuatKhoVM.LoaiHang.isEmpty ? .gray : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.blue.opacity(0.08))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
        }
    }
    // MARK: - SL tồn, SL trả
    private var soLuongSection: some View {
        HStack(spacing: 16) {
            // Số lượng tồn
            VStack(alignment: .leading, spacing: 8) {
                Text("SL Tồn")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text("\(xuatKhoVM.slTon)").frame(width: 120, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }

            // Số lượng xuất
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text("SL Trả")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("0", text: $xuatKhoVM.slTra).frame(width: 120)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
            Spacer()
        }
    }
    
    //MARK: - Ngày trả
    private var ngayThangSection: some View {
        HStack(spacing: 16) {
            // Ngày xuất
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text("Ngày trả")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Text(currentDate).frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    ).onAppear{
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        xuatKhoVM.NgayTra = formatter.string(from: date)
                    }
            }
        }
    }
    private func setupInitialDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = formatter.string(from: date)
    }
    
    // MARK: - Nhan Vien Section
    private var nhanVienSection: some View {
        VStack(spacing: 16) {
            // Mã nhân viên
            HStack(spacing: 12) {
                Text("Mã NV")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 60, alignment: .leading)
                
                TextField("Mã nhân viên", text: $xuatKhoVM.MaNv)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    ).onChange(of: xuatKhoVM.MaNv) { newValue in
                        // Tự động lấy thông tin khi mã NV thay đổi (nhập tay)
                        if !newValue.isEmpty && newValue.count >= 3 {
                            fetchEmployeeInfo(employeeID: newValue)
                        }
                    }
                    .onSubmit {
                        // Lấy thông tin khi nhấn Enter
                        if !xuatKhoVM.MaNv.isEmpty {
                            fetchEmployeeInfo(employeeID: xuatKhoVM.MaNv)
                        }
                    }
                
                Button {
                    withAnimation {
                        showScran = true
                    }
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Tên nhân viên
            HStack {
                Text("Tên NV")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 65, alignment: .leading)
                
                TextField("Tên nhân viên", text: $xuatKhoVM.TenNv)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // Số điện thoại
            HStack {
                HStack(spacing: 4) {
                    Text("Liên hệ")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("Số điện thoại", text: $xuatKhoVM.SDT)
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Confirm Button
    private var confirmButton: some View {
        Button {
            submitTra()
        } label: {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("XÁC NHẬN")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(Color.blue)
        .cornerRadius(16)
        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        .disabled(isLoading)
    }
    // MARK: Event
    private func submitTra() {
        // Validation and submission logic
        guard !xuatKhoVM.phanLoai.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng nhập phân loại"
            return
        }
        
        guard !xuatKhoVM.LoaiHang.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng chọn kho nhận"
            return
        }
        guard !xuatKhoVM.TenNv.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng không bỏ trống tên nhân viên"
            return
        }
        guard !xuatKhoVM.MaNv.isEmpty else {
            xuatKhoVM.errorMessage = "Yêu cầu nhập mã nhân viên"
            return
        }
        guard let tra = Int(xuatKhoVM.slTra) else {
            xuatKhoVM.errorMessage = "Giá trị nhập không hợp lệ"
            return
        }
        guard tra > 0 else {
            xuatKhoVM.errorMessage = "Số lượng trả không hợp lệ"
            return
        }
//        guard let muon = Int(xuatKhoVM.slTon) else {
//            xuatKhoVM.errorMessage = "Giá trị trả không hợp lệ"
//            return
//        }
//        if tra > muon {
//            xuatKhoVM.errorMessage = "Giá trị trả không hợp lệ. Không được trả quá số lượng mượn"
//            return
//        }
        if(xuatKhoVM.TenNv == "Không tìm thấy thông tin" ||  xuatKhoVM.TenNv == "Không xác định" || xuatKhoVM.SDT == "Vui lòng nhập thủ công"){
            xuatKhoVM.errorMessage = "Thông tin nhân viên không hợp. Yêu cầu nhập lại!"
            return
        }
        isLoading = true
        // Call API or perform submission logic
        xuatKhoVM.TraStock(stock: selectKho, adid: userLogin?.chR_ADID ?? "" , item: item){_ in
            DispatchQueue.main.async {
                isLoading = false
                xuatKhoVM.ResetFrom()
                dismiss()
            }
        }
    }
    // MARK: - Helper Functions
    private func handleBarcodeScanned(code: String) {
        // Handle barcode scanning logic
        xuatKhoVM.MaNv = code
        fetchEmployeeInfo(employeeID: code)
    }
    // Hàm lấy thông tin nhân viên
    private func fetchEmployeeInfo(employeeID: String) {
        isLoading = true
        xuatKhoVM.getUserInforData(employeeID: employeeID) { success in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    // Cập nhật thông tin từ API
                    xuatKhoVM.TenNv = self.xuatKhoVM.dataUser?.chR_EMPLOYEE_NAME ?? "Không xác định"
                    xuatKhoVM.SDT = self.xuatKhoVM.dataUser?.chR_PHONE_NO ?? "Không có trên hệ thống"
                } else {
                    // Giữ nguyên giá trị nhập tay nếu không tìm thấy
                    xuatKhoVM.TenNv = "Không tìm thấy thông tin"
                    xuatKhoVM.SDT = "Vui lòng nhập thủ công"
                }
            }
        }
    }
}

