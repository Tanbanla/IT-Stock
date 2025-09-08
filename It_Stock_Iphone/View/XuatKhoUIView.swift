//
//  XuatKhoUIView.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

import SwiftUI
struct XuatKhoUIView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @StateObject private var masterGoodVM = MasterGoodViewModel()
    @StateObject private var xuatKhoVM = XuatKhoViewModel()
    @Binding var userLogin: UserData?
    @State private var currentDate: String = ""
    
    @State private var showScran: Bool = false
    @State private var ScranEmployee: Bool = false
    @State private var isLoading: Bool = false
    // Hiển thị lịch
    @State private var formattedDate: String = ""
    @State private var selectedDate = Date()
    @State private var showCanlender: Bool = false
    // cho phần tím kiếm
    @State private var searchText = ""
    @State private var showSuggestions = false
    @State private var allProducts: [MasterGoodData] = []
    @State private var filteredProducts: [MasterGoodData] = []
    
    @Environment(\.dismiss) private var dismiss
    let listKho: [FactoryData]?
    let selectKho: String
    
    var body: some View {
        ZStack {
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
                        if(xuatKhoVM.loai == "Chuyển kho"){
                            khoNhanSection
                        }
                        
                        // Loại hàng
                        loaiHangSection
                        
                        // Số lượng
                        soLuongSection
                        
                        // Ngày tháng
                        ngayThangSection
                        if(xuatKhoVM.loai != "Chuyển kho"){
                            // Thông tin nhân viên
                            nhanVienSection
                            
                            // Lý do
                            lyDoSection
                        }
                        
                        // Button Xác nhận
                        confirmButton
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.white)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                )
                .onAppear{
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    xuatKhoVM.NgayTra = formatter.string(from: date)
                }
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
                searchText = ""
                ScranEmployee = false
            }
        } message: {
            Text("Xuất thiết bị thành công")
        }
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                showScran = false
                handleBarcodeScanned(code: code)
            }
        }
        .onAppear {
            setupInitialDate()
            loadProducts()
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
                            filterProducts()
                            xuatKhoVM.phanLoai = ""
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
            if showSuggestions && !filteredProducts.isEmpty && xuatKhoVM.phanLoai == "" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gợi ý")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredProducts, id: \.id) { product in
                                Button {
                                    selectProduct(product)
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
        // Cập nhật các thông tin khác
        handleBarcodeScanned(code: product.chR_CODE_GOODS ?? "")
        showSuggestions = false
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
                ForEach(listKho ?? [], id: \.self.chR_STOCK_NAME) { khoNhan in
                    if(khoNhan.chR_STOCK_NAME != selectKho){
                        Button {
                            xuatKhoVM.khoNhan = khoNhan.chR_STOCK_NAME
                        } label: {
                            Text(khoNhan.chR_STOCK_NAME)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "building.2")
                        .foregroundColor(.blue)
                    
                    Text(xuatKhoVM.khoNhan.isEmpty ? "Chọn kho nhận" : xuatKhoVM.khoNhan)
                        .font(.system(size: 16))
                        .foregroundColor(xuatKhoVM.khoNhan.isEmpty ? .gray : .primary)
                    
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
                    Text("SL Xuất")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("0", text: $xuatKhoVM.slXuat).frame(width: 120)
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
            }.onAppear{
                xuatKhoVM.NgayXuat = currentDate
            }
            if(xuatKhoVM.loai == "Cho mượn"){
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
                    Button(action: {
                        showCanlender.toggle()
                    }) {
                        Text("\(formattedDate)").frame(minWidth: 120, minHeight: 20)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .sheet(isPresented: $showCanlender) {
                        CustomDatePickerSheet(
                            selectedDate: $selectedDate,
                            formattedDate: $formattedDate,
                            isPresented: $showCanlender,
                            NgayTra: $xuatKhoVM.NgayTra
                        )
                    }
                }
            }
            Spacer()
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
                    .onChange(of: xuatKhoVM.MaNv) { newValue in
                        if !newValue.isEmpty && newValue.count >= 8 {
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
                        ScranEmployee = true
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
                TextEditor(text: $xuatKhoVM.LyDo)
                    .frame(height: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                
                if xuatKhoVM.LyDo.isEmpty {
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("XÁC NHẬN")
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
    //MARK: - Custom select time
    // Custom sheet view for date picker
    struct CustomDatePickerSheet: View {
        @Binding var selectedDate: Date
        @Binding var formattedDate: String
        @Binding var isPresented: Bool
        @Binding var  NgayTra: String

        var body: some View {
            VStack {
                // Title
                Text("Chọn ngày trả")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()

                // DatePicker with GraphicalDatePickerStyle for a better appearance
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .padding()

                // "Done" button
                Button(action: {
                    formattedDate = formatDate(selectedDate)
                    isPresented = false
                    NgayTra = formatDate(selectedDate)
                }) {
                    Text("Xong")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }

        // Function to format the date as "yyyy-MM-dd"
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
    }
    // MARK: - Helper Functions
    private func handleBarcodeScanned(code: String) {
        // Handle barcode scanning logic
        if ScranEmployee{
            xuatKhoVM.MaNv = code
            fetchEmployeeInfo(employeeID: code)
        }else{
            xuatKhoVM.phanLoai = code
            xuatKhoVM.getPhanLoaiAPI(stockName: selectKho, code: code) {_ in 
                DispatchQueue.main.async {
                    self.isLoading = false
                    xuatKhoVM.IdGood = self.xuatKhoVM.data?.id ?? 0
                    xuatKhoVM.phanLoai = self.xuatKhoVM.data?.nvchR_ITEM_NAME ?? code
                    xuatKhoVM.slTon = String((self.xuatKhoVM.data?.inT_QTY_OLD ?? 0) + (self.xuatKhoVM.data?.inT_QTY_NEW ?? 0))
                    
                    searchText = self.xuatKhoVM.data?.nvchR_ITEM_NAME ?? code
                }
            }
            ScranEmployee = false
        }
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
        
        guard let quantity = Int(xuatKhoVM.slXuat), quantity > 0 else {
            xuatKhoVM.errorMessage = "Số lượng xuất phải là số nguyên dương"
            return
        }
        guard let ton = Int(xuatKhoVM.slTon) else {
            xuatKhoVM.errorMessage = "Giá trị nhập không hợp lệ"
            return
        }

        let total = ton - quantity
        guard total >= 0 else {
            xuatKhoVM.errorMessage = "Số lượng xuất vượt quá số lượng tồn"
            return
        }
        xuatKhoVM.TongSl = total
        guard isNgayTraValid() else {
            xuatKhoVM.errorMessage = "Ngày trả không được vượt quá 3 tháng so với ngày xuất"
            return
        }
        if(xuatKhoVM.loai != "Chuyển kho"){
            guard !xuatKhoVM.TenNv.isEmpty else {
                xuatKhoVM.errorMessage = "Vui lòng không bỏ trống tên nhân viên"
                return
            }
            guard !xuatKhoVM.MaNv.isEmpty else {
                xuatKhoVM.errorMessage = "Yêu cầu nhập mã nhân viên"
                return
            }
            guard !xuatKhoVM.LyDo.isEmpty else {
                xuatKhoVM.errorMessage = "Vui lòng nhập lý do xuất kho"
                return
            }
            guard !xuatKhoVM.SDT.isEmpty else {
                xuatKhoVM.errorMessage = "Vui lòng nhập số điện thoại liên hệ"
                return
            }
            if(xuatKhoVM.TenNv == "Không tìm thấy thông tin" ||  xuatKhoVM.TenNv == "Không xác định" || xuatKhoVM.SDT == "Vui lòng nhập thủ công"){
                xuatKhoVM.errorMessage = "Thông tin nhân viên không hợp. Yêu cầu nhập lại!"
                return
            }
        }
        isLoading = true
        // Call API or perform submission logic
        xuatKhoVM.MuonOrXuat(stock: selectKho, adid: userLogin?.chR_ADID ?? "", SectionAdid: userLogin?.chR_COST_CENTER ?? ""){_ in
            DispatchQueue.main.async {
                isLoading = false
                //xuatKhoVM.ResetFrom()
            }
        }
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
                    xuatKhoVM.SectionNv = self.xuatKhoVM.dataUser?.chR_SECTION ?? "Không xác định"
                } else {
                    // Giữ nguyên giá trị nhập tay nếu không tìm thấy
                    xuatKhoVM.TenNv = "Không tìm thấy thông tin"
                    xuatKhoVM.SDT = "Vui lòng nhập thủ công"
                }
            }
        }
    }
    // Hàm kiểm tra ngày trả không vượt quá 3 tháng
    private func isNgayTraValid() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // hoặc định dạng bạn đang sử dụng
        
        guard let ngayXuatDate = dateFormatter.date(from: xuatKhoVM.NgayXuat)
              else {
            return false
        }
        guard let ngayTraDate = dateFormatter.date(from: xuatKhoVM.NgayTra) else{
            return false
        }
        // Tính khoảng cách giữa hai ngày
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: ngayXuatDate, to: ngayTraDate)
        
        // Kiểm tra không vượt quá 3 tháng
        if let monthsDifference = components.month, monthsDifference <= 3 {
            return true
        }
        
        return false
    }
}
//#Preview {
//    XuatKhoUIView(listKho: nil, selectKho: "BIVN-F1")
//}
