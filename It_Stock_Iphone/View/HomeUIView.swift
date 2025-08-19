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
    @State private var factorySelect: String = ""
    @State private var showMessage: Bool = false
    @State private var showExportView = false
    @State private var showImportView = false
    @State private var showCheckView = false
    @StateObject private var xuatKhoVM = XuatKhoViewModel()
    
    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(
//                colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.03)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header với notification
                    headerView
                    
                    // User info card
                    userInfoCard
                    
                    // Kho selection
                    factorySelectionView
                    
                    // Action buttons
                    actionButtonsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .alert(isPresented: $showMessage) {
            Alert(
                title: Text("Thông báo"),
                message: Text("Vui lòng chọn kho trước khi thực hiện thao tác"),
                dismissButton: .default(Text("Đã hiểu"))
            )
        }
        .fullScreenCover(isPresented: $showExportView) {
            XuatKhoUIView(listKho: xuatKhoVM.ListStock ?? [])
                .onAppear {
                    if xuatKhoVM.ListStock == nil {
                        xuatKhoVM.getListFactory(section: "3510")
                    }
                }
        }
        .fullScreenCover(isPresented: $showImportView) {
            NhapKhoUIView(selectKho: factorySelect, section: "3510", adid: "khanhmf")
        }
        .fullScreenCover(isPresented: $showCheckView) {
            KiemKeUIView()
        }
        .onAppear {
            //factoryVM.fetchFactories(section: "3510")
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Xin chào!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Text("Quản lý kho")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button {
                // Notification action
            } label: {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - User Info Card
    private var userInfoCard: some View {
        HStack(spacing: 16) {
            Image(isShowIcon ? "man" : "woman")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue.opacity(0.3), lineWidth: 2))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
//                Text(userDataManager.currentUser?.nvchR_NAME ?? "Không xác định")
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(.primary)
//                
//                Text(userDataManager.currentUser?.chR_COST_CENTER ?? "Không xác định")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button {
                // Logout action
            } label: {
                VStack(spacing: 2) {
                    Image(systemName: "power")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("Log Out")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.red)
                }
                .padding(8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Factory Selection
    private var factorySelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                
                Text("Chọn kho làm việc")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("*")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            if factoryVM.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    Text("Đang tải danh sách kho...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            } else {
                Menu {
                    ForEach(factoryVM.factories, id: \.self) { factory in
                        Button {
                            factoryVM.selectedFactory = factory
                            factorySelect = factory
                        } label: {
                            HStack {
                                Text(factory)
                                if factory == factoryVM.selectedFactory {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "building.2")
                            .foregroundColor(.blue)
                        
                        Text(factoryVM.selectedFactory.isEmpty ? "Chọn kho" : factoryVM.selectedFactory)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(factoryVM.selectedFactory.isEmpty ? .gray : .primary)
                        
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
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            actionButton(
                icon: "xuatkho",
                title: "XUẤT KHO - CHO MƯỢN",
                color: Color.purple,
                action: {
                    if factorySelect != "" {
                        showExportView.toggle()
                    } else {
                        showMessage = true
                    }
                }
            )
            
            actionButton(
                icon: "nhapkho",
                title: "NHẬP KHO TÁI SỬ DỤNG",
                color: Color.blue,
                action: {
                    if factorySelect != "" {
                        showImportView.toggle()
                    } else {
                        showMessage = true
                    }
                }
            )
            
            actionButton(
                icon: "scan_qr",
                title: "KIỂM KÊ",
                color: Color.green,
                action: {
                    showCheckView.toggle()
                }
            )
        }
    }
    
    private func actionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 2)
                
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}
#Preview {
    HomeUIView()
}
