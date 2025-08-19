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
    @State private var currentDate: String = ""
    @State private var formattedDate: String = ""
    @State private var lyDo: String = ""
    @State private var showScran: Bool = false
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
        .sheet(isPresented: $showScran) {
            BarcodeScannerView(viewModel: viewModel) { code in
                // Handle barcode result
            }
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Phân loại")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            HStack(spacing: 12) {
                TextField("Quét mã vạch", text: .constant(""))
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
            VStack(alignment: .leading, spacing: 8) {
                Text("SL Max")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                TextField("", text: .constant(""))
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
            VStack(alignment: .leading, spacing: 8) {
                Text("SL Min")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                TextField("", text: .constant(""))
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Tồn kho")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                
                TextField("", text: .constant(""))
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
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 2) {
                    Text("Kiểm kê")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("*")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                TextField("", text: .constant(""))
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
        }
    }
    
    // MARK: - Chênh Lệch Section
    private var chenhLechSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chênh lệch")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
            
            TextField("", text: .constant(""))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
                .disabled(true) // Read-only
        }
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
                )
        }
    }
    
    // MARK: - Confirm Button
    private var confirmButton: some View {
        Button {
            // Handle confirm action
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.white)
                Text("XÁC NHẬN")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
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
        }
        .padding(.top, 10)
    }
}
#Preview {
    KiemKeUIView()
}
