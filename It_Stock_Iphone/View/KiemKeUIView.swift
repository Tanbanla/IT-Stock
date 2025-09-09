//
//  KiemKeUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

import SwiftUI

struct KiemKeUIView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @StateObject private var kiemKeVM = KiemKeViewModel()
    @StateObject private var masterGoodVM = MasterGoodViewModel()
    @Binding var userLogin: UserData?
    @State private var lyDo: String = ""
    @State private var showScran: Bool = false
    @Environment(\.dismiss) private var dismiss
    // cho phần tím kiềm
    @State private var searchText = ""
    @State private var showSuggestions = false
    @State private var allProducts: [MasterGoodData] = []
    @State private var filteredProducts: [MasterGoodData] = []
    
    let selectKho: String
    
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
                        // Phân loại (Barcode)
                        barcodeSection
                        
                        // Loại hàng
                        loaiHangSection
                        
                        // Số lượng
                        quantitySection
                        
                        // Chênh lệch
                        chenhLechSection
                        
                        // Lý do
                        lyDoSection
                        
                        // Button Xác nhận
                        confirmButton
                    }
                    .padding(.horizontal)
                    //.padding(.vertical, 20)
                }
                .background(Color.white)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .alert("Lỗi", isPresented: .constant(kiemKeVM.errorMessage != nil)) {
            Button("OK") {
                kiemKeVM.errorMessage = nil
            }
        } message: {
            Text(kiemKeVM.errorMessage ?? "")
        }
        .alert("Thành công", isPresented: $kiemKeVM.isSuccess) {
            Button("OK") {
                kiemKeVM.ResetFrom()
                lyDo = ""
                searchText = ""
            }
        } message: {
            Text("Kiểm kê thiết bị thành công")
        }
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                handleBarcodeScanned(code: code)
                showScran = false
            }
        }
        .onAppear {
            setupInitialDate()
            loadProducts()
        }
    }
    private func setupInitialDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        kiemKeVM.NgayKiemKe = formatter.string(from: date)
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
            
            Text("KIỂM KÊ")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
            
            Spacer()
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Barcode Section
    private var barcodeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phân loại")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            HStack(spacing: 12) {
                TextField("Mã sản phẩm", text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .onChange(of: searchText) { newValue in
                        if !newValue.isEmpty {
                            showSuggestions = true
                            kiemKeVM.phanLoai = ""
                            filterProducts()
                        } else {
                            showSuggestions = false
                        }
                    }
                    .overlay(alignment: .trailing) {
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                showSuggestions = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                
                Button {
                    withAnimation {
                        showScran = true
                    }
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            // Hiển thị danh sách gợi ý
            if (showSuggestions && !filteredProducts.isEmpty && kiemKeVM.phanLoai == ""){
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gợi ý")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredProducts, id: \.id) { product in
                                Button {
                                    selectProduct(product)
                                    showSuggestions = false
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(product.chR_CODE_GOODS ?? "")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text(product.nvchR_ITEM_NAME)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onAppear{
                        if filteredProducts.count == 1 {
                            selectProduct(filteredProducts[0])
                        }
                    }
                }
            }
        }
    }
    private func loadProducts() {
        masterGoodVM.fetchMasterGood(section: (userLogin?.chR_COST_CENTER ?? "")) {_ in
            DispatchQueue.main.async {
                self.allProducts = masterGoodVM.phanloai ?? []
            }
        }
    }

    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = allProducts
        } else {
            filteredProducts = allProducts.filter { product in
                (product.chR_CODE_GOODS ?? "").localizedCaseInsensitiveContains(searchText) ||
                product.nvchR_ITEM_NAME.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    private func selectProduct(_ product: MasterGoodData) {
        //searchText = product.nvchR_ITEM_NAME
        showSuggestions = false
        
        // Cập nhật các thông tin khác
        handleBarcodeScanned(code: "\(product.chR_CODE_GOODS ?? "")")
    }
    
    // MARK: - Loại Hàng Section
    private var loaiHangSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text("Loại hàng")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            Menu {
                ForEach(kiemKeVM.listLoaiHang, id: \.self) { loaiHang in
                    Button {
                        kiemKeVM.LoaiHang = loaiHang
                    } label: {
                        Text(loaiHang)
                    }
                }
            } label: {
                HStack {
                    Text(kiemKeVM.LoaiHang.isEmpty ? "Chọn loại hàng" : kiemKeVM.LoaiHang)
                        .font(.system(size: 16))
                        .foregroundColor(kiemKeVM.LoaiHang.isEmpty ? .gray : .primary)
                    
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
    
    // MARK: - Quantity Section
    private var quantitySection: some View {
        HStack(spacing: 16) {
            // Max Quantity
            VStack(alignment: .center, spacing: 8) {
                Text("SL Max")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text(kiemKeVM.slMax)
                    .frame(minWidth: 50, minHeight: 22)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
            }
            
            // Min Quantity
            VStack(alignment: .center, spacing: 8) {
                Text("SL Min")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text(kiemKeVM.slMin)
                    .frame(minWidth: 50, minHeight: 22)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
            }
            
            // Tồn kho
            VStack(alignment: .center, spacing: 8) {
                Text("Tồn kho")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text(kiemKeVM.slTon)
                    .frame(minWidth: 50, minHeight: 22)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
            }
            
            // Kiểm kê
            VStack(alignment: .center, spacing: 8) {
                HStack(spacing: 2) {
                    Text("Kiểm kê")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("0", text: $kiemKeVM.slKiemKe)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                    .onChange(of: kiemKeVM.slKiemKe) { newValue in
                        let ton = Int(kiemKeVM.slTon) ?? 0
                        let kiemKe = Int(newValue) ?? 0
                        let lech = ton - kiemKe
                        kiemKeVM.slLech = String(lech)
                    }
                    .onAppear {
                        let ton = Int(kiemKeVM.slTon) ?? 0
                        let kiemKe = Int(kiemKeVM.slKiemKe) ?? 0
                        let lech = ton - kiemKe
                        kiemKeVM.slLech = String(lech)
                    }
            }
        }
    }
    
    // MARK: - Chênh Lệch Section
    private var chenhLechSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chênh lệch")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            TextField("", text: $kiemKeVM.slLech)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1)
                )
                .disabled(true) // Read-only
        }
    }
    private var backgroundColor: Color {
        let ton = Int(kiemKeVM.slTon) ?? 0
        let kiemKe = Int(kiemKeVM.slKiemKe) ?? 0
        let lech = ton - kiemKe
        
        return lech != 0 ? Color.red.opacity(0.08) : Color.blue.opacity(0.08)
    }

    private var borderColor: Color {
        let ton = Int(kiemKeVM.slTon) ?? 0
        let kiemKe = Int(kiemKeVM.slKiemKe) ?? 0
        let lech = ton - kiemKe
        
        return lech != 0 ? Color.red.opacity(0.3) : Color.blue.opacity(0.2)
    }
    // MARK: - Lý Do Section
    private var lyDoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text("Lý do")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
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
                .overlay(
                    Group {
                        if lyDo.isEmpty {
                            Text("Nhập lý do kiểm kê...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                    }
                ).onAppear{
                    kiemKeVM.Lydo = lyDo
                }
                .onChange(of: lyDo) { newValue in
                    kiemKeVM.Lydo = lyDo
                }
        }
    }
    
    // MARK: - Confirm Button
    private var confirmButton: some View {
        Button {
            submitInv()
        } label: {
            if kiemKeVM.isLoading{
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            }else{
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.white)
                    Text("XÁC NHẬN")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.blue)
                .cornerRadius(16)
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.top, 10)
    }
    // MARK: - Helper Functions
    private func handleBarcodeScanned(code: String) {
        // Handle barcode scanning logic
        kiemKeVM.getPhanLoaiAPI(stockName: selectKho, code: code) {_ in
            DispatchQueue.main.async {
                kiemKeVM.phanLoai = kiemKeVM.data?.nvchR_ITEM_NAME ?? code
                kiemKeVM.slMin = String(kiemKeVM.data?.inT_MIN ?? 0)
                kiemKeVM.slMax = String(kiemKeVM.data?.inT_MAX ?? 0)
                
                let old = Int(kiemKeVM.data?.inT_QTY_OLD ?? 0);
                let new = Int(kiemKeVM.data?.inT_QTY_NEW ?? 0);
                let total = old + new
                kiemKeVM.slTon = String(total)
                
                searchText = kiemKeVM.data?.nvchR_ITEM_NAME ?? code
            }
        }
    }
    private func submitInv() {
        // Validation and submission logic
        guard !kiemKeVM.LoaiHang.isEmpty else {
            kiemKeVM.errorMessage = "Vui lòng chọn loại kiểm kê"
            return
        }
        
        guard !kiemKeVM.phanLoai.isEmpty else {
            kiemKeVM.errorMessage = "Vui lòng quét mã vạch sản phẩm"
            return
        }
        
        guard !lyDo.isEmpty else {
            kiemKeVM.errorMessage = "Vui lòng nhập lý do kiểm kê"
            return
        }
        
        guard let quantity = Int(kiemKeVM.slKiemKe), quantity > 0 else {
            kiemKeVM.errorMessage = "Số lượng xuất phải là số nguyên dương"
            return
        }
        kiemKeVM.isLoading = true
        // Call API or perform submission logic
        kiemKeVM.InventoryStock(stock: selectKho, adid: userLogin?.chR_ADID ?? "") { _ in
            DispatchQueue.main.async {
                kiemKeVM.isLoading = false
                
            }
        }
    }
}
//#Preview {
//    KiemKeUIView(selectKho: "BINV-F1")
//}
