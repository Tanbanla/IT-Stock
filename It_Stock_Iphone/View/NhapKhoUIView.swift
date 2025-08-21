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
    @State private var currentDate: String = ""
    @State private var formattedDate: String = ""
    @State private var phanLoai: String = ""
    @State private var soLuong: String = ""
    @State private var lyDo: String = ""
    @State private var showScran: Bool = false
    @State private var isLoading: Bool = false
    @State private var idGood: Int = 0
    
    
    @Environment(\.dismiss) private var dismiss
    
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
                    VStack(spacing: 24) {
                        // Phân loại (Barcode)
                        barcodeSection
                        
                        // Kho nhập
                        khoNhapSection
                        
                        // Số lượng
                        soLuongSection
                        
                        // Ngày nhập
                        ngayNhapSection
                        
                        // Lý do
                        lyDoSection
                        
                        // Button Nhập kho
                        submitButton
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.white)
            }
        }
        .alert("Thành công", isPresented: $masterGoodVM.isSuccess) {
            Button("OK") {
                resetForm()
            }
        } message: {
            Text("Nhập kho thành công")
        }
        .alert("Lỗi", isPresented: .constant(masterGoodVM.errorMessage != nil)) {
            Button("OK") {
                masterGoodVM.errorMessage = nil
            }
        } message: {
            Text(masterGoodVM.errorMessage ?? "")
        }
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                showScran = false
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
            
            Text("NHẬP HÀNG TÁI SỬ DỤNG")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Barcode Section
    private var barcodeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Phân loại")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            HStack(spacing: 12) {
                TextField("Quét mã vạch", text: $phanLoai)
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
                        //.background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    // MARK: - Kho Nhap Section
    private var khoNhapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kho nhập")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            HStack {
                Image(systemName: "building.2")
                    .foregroundColor(.blue)
                
                Text(selectKho)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
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
    
    // MARK: - So Luong Section
    private var soLuongSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Số lượng")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            TextField("Nhập số lượng", text: $soLuong)
                .keyboardType(.numberPad)
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
    
    // MARK: - Ngay Nhap Section
    private var ngayNhapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ngày nhập")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                
                Text(currentDate)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
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
                
                if lyDo.isEmpty {
                    Text("Nhập lý do nhập kho...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        Button {
            submitImport()
        } label: {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            } else {
                HStack {
                    Image(systemName: "square.and.arrow.down.fill")
                    Text("NHẬP KHO")
                        .font(.system(size: 18, weight: .bold))
                }        .frame(maxWidth: .infinity)
                    .frame(height: 56)
                .foregroundColor(.white)
            }
        }
        .background(Color.blue)
        .cornerRadius(16)
        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        .disabled(isLoading)
    }
    
    // MARK: - Helper Functions
    private func handleBarcodeScanned(code: String) {
        isLoading = true
        masterGoodVM.getMasterByCode(stockName: selectKho, code: code) {_ in 
            DispatchQueue.main.async {
                self.isLoading = false
                self.phanLoai = self.masterGoodVM.data?.nvchR_ITEM_NAME ?? code
                self.idGood = self.masterGoodVM.data?.id ?? 0
            }
        }
    }
    
    private func setupInitialDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = formatter.string(from: date)
    }
    
    private func submitImport() {
        guard let quantity = Int(soLuong), quantity > 0 else {
            masterGoodVM.errorMessage = "Số lượng phải là số nguyên dương"
            return
        }
        
        guard !phanLoai.isEmpty else {
            masterGoodVM.errorMessage = "Vui lòng quét mã vạch sản phẩm"
            return
        }
        
        guard !lyDo.isEmpty else {
            masterGoodVM.errorMessage = "Vui lòng nhập lý do nhập kho"
            return
        }
        
        isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let date = dateFormatter.date(from: currentDate) else {
            masterGoodVM.errorMessage = "Lỗi định dạng ngày tháng"
            isLoading = false
            return
        }
        
        let request = ImportUsedGoodsRequest(
            itemId: idGood,
            itemName: phanLoai,
            warehouse: selectKho,
            quantity: quantity,
            date: date,
            userId: adid,
            reason: lyDo
        )
        
        masterGoodVM.importUsedGoods(request: request) { success in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    self.resetForm()
                }
            }
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
