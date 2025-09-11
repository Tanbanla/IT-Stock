//
//  ListBorrowUIView.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//

import SwiftUI

struct ListBorrowUIView: View {
    @State private var searchText = ""
    @StateObject private var BorrowListVM = ListBorrowViewModel()
    @Binding var userLogin: UserData?
    @State private var selectedItem: ListBorrowData? = nil
    @State private var showTraView: Bool = false
    @Binding var factorySelect: String
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    Text("DANH SÁCH CHO MƯỢN")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
                HStack {
                    SearchBar1(text: $searchText)
                }
                .padding(.horizontal)
                if BorrowListVM.isLoading {
                     ProgressView("Đang tải dữ liệu...")
                         .padding(.top, 50)
                } else{
                    BorrowListView(
                         borrowItems: filteredBorrowItems,
                         searchText: searchText,
                         selectedItem: $selectedItem,
                         showTraView: $showTraView
                     )
                 }
            }
        }.alert("Lỗi", isPresented: .constant(BorrowListVM.errorMessage != nil)) {
            Button("OK") {
                BorrowListVM.errorMessage = nil
            }
        } message: {
            Text(BorrowListVM.errorMessage ?? "")
        }
        .onAppear {
            loadData()
        }
        .refreshable {
            loadData()
        }
        .fullScreenCover(item: $selectedItem) { item in
            TraTBUIView(userLogin: $userLogin,item: item, selectKho: factorySelect)
        }
    }
    // MARK: - Computed Properties
    private var filteredBorrowItems: [ListBorrowData] {
        guard let listBorrow = BorrowListVM.listBorrow else {
            return []
        }
        
        if searchText.isEmpty {
            return listBorrow
        }
        
        let lowercasedSearchText = searchText.lowercased()
        
        return listBorrow.filter { item in
            (item.nvchR_ITEM_NAME?.lowercased().contains(lowercasedSearchText) ?? false) ||
            (item.chR_PER_SECT?.lowercased().contains(lowercasedSearchText) ?? false) ||
            (item.chR_KHO?.lowercased().contains(lowercasedSearchText) ?? false)
        }
    }
    // MARK: - Methods
    private func loadData() {
        // Giả sử lấy section từ user manager
        let section = userLogin?.chR_COST_CENTER// Thay bằng userDataManager.currentUser?.chR_COST_CENTER
        BorrowListVM.getListBorrow(section: section ?? "") {_ in
            DispatchQueue.main.async {
                
            }
        }
    }
}

// MARK: - Search Section
struct SearchBar1: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Nhập tên thiết bị cần tìm...", text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Huỷ")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
// MARK: - List BorrowView
 struct BorrowListView: View {
     let borrowItems: [ListBorrowData]
     let searchText: String
     @Binding var selectedItem: ListBorrowData?
     @Binding var showTraView: Bool
     
     var body: some View {
         ScrollView {
             LazyVStack(spacing: 12) {
                 if borrowItems.isEmpty {
                     if searchText.isEmpty {
                         EmptyStateView()
                     } else {
                         NoResultsView(searchText: searchText)
                     }
                 } else {
                     ForEach(borrowItems) { item in
                         BorrowItemCard(item: item){
                             // Khi nhấn nút "Trả"
                             selectedItem = item
                             showTraView = true
                         }
                     }
                 }
             }
             .padding()
         }
     }
     // MARK: - Borrow Item Card
     struct BorrowItemCard: View {
         let item: ListBorrowData
         var onReturn: () -> Void
         
         var body: some View {
             HStack(spacing: 0) {
                 // Phần thông tin chi tiết
                 VStack(alignment: .leading, spacing: 8) {
                     // Header với tên thiết bị và trạng thái
                     HStack {
                         Text(item.nvchR_ITEM_NAME ?? "Không có tên")
                             .font(.system(size: 16, weight: .bold))
                             .foregroundColor(.primary)
                             .lineLimit(1)
                         
                         Spacer()
                         
                         Text(item.chR_TYPE_GOODS ?? "")
                             .font(.system(size: 11, weight: .semibold))
                             .padding(.horizontal, 6)
                             .padding(.vertical, 3)
                             .background(Color.blue)
                             .foregroundColor(.white)
                             .cornerRadius(4)
                     }
                     
                     // Thông tin chi tiết
                     VStack(alignment: .leading, spacing: 4) {
                         InfoRow(label: "Ngày xuất:", value: formatDateString(item.dtM_DATE_IN_OUT) ?? "")
                         InfoRow(label: "Tên NV:", value: item.chR_PER_SECT ?? "N/A")
                         InfoRow(label: "Mã NV:", value: item.chR_CODE_PER_SECT ?? "N/A")
                         InfoRow(label: "Phòng ban:", value: item.chR_SECT ?? "Không xác định")
                         InfoRow(label: "Kho:", value: item.chR_KHO ?? "N/A")
                         
                         if let reason = item.nvchR_REASON_IN_OUT, !reason.isEmpty {
                             InfoRow(label: "Lý do:", value: reason)
                                 .lineLimit(1)
                         }
                     }
                     .font(.system(size: 13))
                 }
                 .padding(.vertical, 12)
                 .padding(.leading, 12)
                 .padding(.trailing, 8)
                 
                 // Phần số lượng và nút trả
                 VStack(spacing: 0) {
                     // Số lượng đang mượn
                     VStack(spacing: 4) {
                         Text("Đang mượn")
                             .font(.system(size: 12, weight: .medium))
                             .foregroundColor(.white)
                             .multilineTextAlignment(.center)
                         
                         Text("\(item.inT_QUANTITY_REMAINING)")
                             .font(.system(size: 20, weight: .bold))
                             .foregroundColor(.white)
                     }
                     .frame(width: 80)
                     .padding(.vertical, 8)
                     .background(Color.blue)
                     
                     // Nút trả
                     Button(action: onReturn) {
                         Text("Trả")
                             .font(.system(size: 16, weight: .bold))
                             .foregroundColor(.white)
                             .frame(maxWidth: .infinity, maxHeight: .infinity)
                     }
                     .frame(height: 55)
                     .background(Color.red)
                 }
                 .frame(width: 80)
                 .cornerRadius(8)
                 .padding(.trailing, 12)
                 .padding(.vertical, 8)
             }
             .background(Color.white)
             .cornerRadius(12)
             .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
             .padding(.horizontal, 1)
         }
     }
//     struct BorrowItemCard: View {
//         let item: ListBorrowData
//         var onReturn: () -> Void
//         
//         var body: some View {
//             VStack(spacing: 4) {
//                 //VStack(alignment: .leading, spacing: 8) {
//                     // Tên thiết bị
//                     HStack {
//                         Text(item.nvchR_ITEM_NAME ?? "Không có tên")
//                             .font(.system(size: 16, weight: .bold))
//                             .foregroundColor(.primary)
//                         // Trạng thái
//                         Text(item.chR_TYPE_GOODS ?? "")
//                         
//                             .font(.system(size: 12, weight: .semibold))
//                             .padding(.horizontal, 8)
//                             .padding(.vertical, 4)
//                             .background(.blue)
//                             .foregroundColor(.white)
//                             .cornerRadius(6)
//                         Spacer()
//                     }.padding(.top, 4)
//                 //}
//                 HStack{
//                     // Thông tin chi tiết
//                     VStack(alignment: .leading, spacing: 4) {
//                         InfoRow(label: "Ngày xuất:", value: formatDateString(item.dtM_DATE_IN_OUT) ?? "")
//                         InfoRow(label: "Tên NV:", value: item.chR_PER_SECT ?? "N/A")
//                         InfoRow(label: "Mã NV:", value: item.chR_CODE_PER_SECT ?? "N/A")
//                         InfoRow(label: "Phòng ban:", value: item.chR_SEC ?? "Không xác định")
//                         InfoRow(label: "Kho:", value: item.chR_KHO ?? "N/A")
//                         if let reason = item.nvchR_REASON_IN_OUT, !reason.isEmpty {
//                             InfoRow(label: "Lý do:", value: reason)
//                         }
//                         Spacer()
//                     }
//                     .font(.system(size: 14))
//                     HStack(spacing: 0){
//                         Text("Đang mượn").font(.system(size: 13, weight: .medium)).foregroundStyle(.white).frame(width: 40, alignment: .leading)
//                         Text("\(item.inT_QUANTITY_REMAINING)").font(.system(size: 22, weight: .bold)).foregroundStyle(.white)
//                     }.frame(width: 70).padding(.horizontal,10).padding(.vertical, 10).background(.blue).cornerRadius(12).padding(.trailing,4).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                     
//                     Button(action: onReturn){
//                         Text("Trả").bold().foregroundStyle(.white).frame(height: 200)
//                     }.padding(.horizontal, 4).background(.red).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                 }
//             }
//             .padding(.leading, 12)
//             .background(Color.white)
//             .cornerRadius(12)
//             .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//         }
//     }
     // MARK: - Helper Views
     struct InfoRow: View {
         let label: String
         let value: String
         
         var body: some View {
             HStack(alignment: .top) {
                 Text(label)
                     .foregroundColor(.secondary)
                     .frame(width: 70, alignment: .leading)
                 
                 Text(value)
                     .foregroundColor(.primary)
                     .multilineTextAlignment(.leading)
                 
                 Spacer()
             }
         }
     }

     struct EmptyStateView: View {
         var body: some View {
             VStack(spacing: 16) {
                 Image(systemName: "list.bullet.clipboard")
                     .font(.system(size: 50))
                     .foregroundColor(.gray)
                 
                 Text("Không có dữ liệu cho mượn")
                     .font(.system(size: 16, weight: .medium))
                     .foregroundColor(.gray)
             }
             .padding(.top, 100)
         }
     }

     struct NoResultsView: View {
         let searchText: String
         
         var body: some View {
             VStack(spacing: 16) {
                 Image(systemName: "magnifyingglass")
                     .font(.system(size: 40))
                     .foregroundColor(.gray)
                 
                 Text("Không tìm thấy kết quả cho '\(searchText)'")
                     .font(.system(size: 16, weight: .medium))
                     .foregroundColor(.gray)
                 
                 Text("Hãy thử từ khóa tìm kiếm khác")
                     .font(.system(size: 14))
                     .foregroundColor(.secondary)
             }
             .padding(.top, 100)
         }
     }
 }
private func formatDateString(_ dateString: String?) -> String? {
    guard let dateString = dateString, !dateString.isEmpty else {
        return nil
    }
    
    // Tạo các formatter
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX") // For ISO format
    
    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "vi_VN") // Vietnamese locale
    outputFormatter.dateFormat = "dd/MM/yyyy" // Định dạng mong muốn
    
    // Thử các định dạng input khác nhau
    let possibleFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd"
    ]
    
    for format in possibleFormats {
        inputFormatter.dateFormat = format
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
    }
    
    return dateString // Trả về nguyên bản nếu không parse được
}

//#Preview {
//    //ListBorrowUIView(factorySelect: "BIVN-F1",)
//}
