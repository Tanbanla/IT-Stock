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
    @State private var currentDate: String = ""
    @State private var lyDo: String = ""
    @State private var showScran: Bool = false
    @State private var isLoading: Bool = false
    @State private var soLuongXuat: String = ""
    @State private var soDienThoai: String = ""
    @State private var tenNhanVien: String = ""
    @State private var soLuongTon: String = "0"
    
    @Environment(\.dismiss) private var dismiss
    let listKho: [FactoryData]?
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Phân loại xuất
                        phanLoaiXuatSection
                        
                        // Phân loại (Barcode)
                        phanLoaiSection
                        
                        // Kho nhận
                        khoNhanSection
                        
                        // Loại hàng
                        loaiHangSection
                        
                        // Số lượng
                        soLuongSection
                        
                        // Ngày tháng
                        ngayThangSection
                        
                        // Thông tin nhân viên
                        nhanVienSection
                        
                        // Lý do
                        lyDoSection
                        
                        // Button Xác nhận
                        confirmButton
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.white)
            }
        }
        .alert("Lỗi", isPresented: .constant(xuatKhoVM.errorMessage != nil)) {
            Button("OK") {
                xuatKhoVM.errorMessage = nil
            }
        } message: {
            Text(xuatKhoVM.errorMessage ?? "")
        }
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                handleBarcodeScanned(code: code)
            }
        }
        .onAppear {
            setupInitialDate()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("XUẤT KHO - CHO MƯỢN")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Phân Loại Xuất Section
    private var phanLoaiXuatSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phân loại xuất")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            Menu {
                ForEach(xuatKhoVM.listLuaChon, id: \.self) { loaiXuat in
                    Button {
                        xuatKhoVM.loai = loaiXuat
                    } label: {
                        HStack {
                            Text(loaiXuat)
                            if loaiXuat == xuatKhoVM.loai {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(xuatKhoVM.loai.isEmpty ? "Chọn loại xuất" : xuatKhoVM.loai)
                        .font(.system(size: 16))
                        .foregroundColor(xuatKhoVM.loai.isEmpty ? .gray : .primary)
                    
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
    }
    
    // MARK: - Phân Loại Section
    private var phanLoaiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phân loại")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            HStack(spacing: 12) {
                TextField("Mã sản phẩm", text: $xuatKhoVM.phanLoai)
                    .disabled(true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                
                Button {
                    withAnimation {
                        showScran = true
                    }
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    // MARK: - Kho Nhận Section
    private var khoNhanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Kho nhận")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            Menu {
                //                                    if let listStock = listKho{
                //                                        ForEach(listStock, id: \.self) { khoNhan in
                //                                            Button {
                //                                                xuatKhoVM.khoNhan = khoNhan
                //                                            } label: {
                //                                                Text(khoNhan.chR_FACTORY ?? "Không có tên") // Hiển thị tên kho
                //                                            }
                //                                        }
                //                                    } else {
                //                                        // Hiển thị khi đang loading hoặc không có data
                //                                        if xuatKhoVM.isLoading {
                //                                            ProgressView()
                //                                        } else {
                //                                            Text("Không có dữ liệu kho")
                //                                                .foregroundColor(.gray)
                //                                        }
                //                                    }
                
                //                                    ForEach(listKho ?? [], id: \.self) { khoNhan in
                //                                        Button {
                //                                            xuatKhoVM.khoNhan = khoNhan.chR_STOCK_NAME
                //                                        } label: {
                //                                            Text(khoNhan.chR_STOCK_NAME)
                //                                        }
                //                                    }
            } label: {
                HStack {
                    Image(systemName: "building.2")
                        .foregroundColor(.blue)
                    
                    Text(xuatKhoVM.LoaiHang.isEmpty ? "Chọn kho nhận" : xuatKhoVM.LoaiHang)
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
            
            Menu {
                ForEach(xuatKhoVM.ListLoaiHang, id: \.self) { loaiHang in
                    Button {
                        xuatKhoVM.LoaiHang = loaiHang
                    } label: {
                        HStack {
                            Text(loaiHang)
                            if loaiHang == xuatKhoVM.LoaiHang {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
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
    }
    
    // MARK: - So Luong Section
    private var soLuongSection: some View {
        HStack(spacing: 16) {
            // Số lượng tồn
            VStack(alignment: .leading, spacing: 8) {
                Text("SL Tồn")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text(soLuongTon)
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
                    Text("SL Xuất")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("0", text: $soLuongXuat)
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
        }
    }
    
    // MARK: - Ngay Thang Section
    private var ngayThangSection: some View {
        HStack(spacing: 16) {
            // Ngày xuất
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text("Ngày xuất")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Text(currentDate).frame(width: 120)
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
            // Ngày dự trả
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text("Ngày trả")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Text(currentDate).frame(width: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            }
        }
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
                    )
                
                Button {
                    withAnimation {
                        showScran = true
                    }
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Tên nhân viên
            HStack {
                Text("Tên NV")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 65, alignment: .leading)
                
                TextField("Tên nhân viên", text: $tenNhanVien)
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
                
                TextField("Số điện thoại", text: $soDienThoai)
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
    
    // MARK: - Ly Do Section
    private var lyDoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Lý do")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $lyDo)
                    .frame(height: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .onChange(of: lyDo) { newValue in
                        xuatKhoVM.LyDo = newValue
                    }
                
                if lyDo.isEmpty {
                    Text("Nhập lý do xuất kho...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Confirm Button
    private var confirmButton: some View {
        Button {
            submitXuatKho()
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
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        .disabled(isLoading)
    }
    
    // MARK: - Helper Functions
    private func handleBarcodeScanned(code: String) {
        // Handle barcode scanning logic
        xuatKhoVM.phanLoai = code
    }
    
    private func setupInitialDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = formatter.string(from: date)
    }
    
    private func submitXuatKho() {
        // Validation and submission logic
        guard !xuatKhoVM.loai.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng chọn loại xuất"
            return
        }
        
        guard !xuatKhoVM.phanLoai.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng quét mã vạch sản phẩm"
            return
        }
        
        guard !xuatKhoVM.LoaiHang.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng chọn kho nhận"
            return
        }
        
        guard let quantity = Int(soLuongXuat), quantity > 0 else {
            xuatKhoVM.errorMessage = "Số lượng xuất phải là số nguyên dương"
            return
        }
        
        guard !soDienThoai.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng nhập số điện thoại liên hệ"
            return
        }
        
        guard !lyDo.isEmpty else {
            xuatKhoVM.errorMessage = "Vui lòng nhập lý do xuất kho"
            return
        }
        
        isLoading = true
        // Call API or perform submission logic
    }
}
#Preview {
    XuatKhoUIView(listKho: nil)
}
