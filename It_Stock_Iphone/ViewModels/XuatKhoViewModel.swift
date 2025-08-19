//
//  XuatKhoViewModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 19/8/25.
//

import Foundation
import Combine
class XuatKhoViewModel: ObservableObject {
    // các trường điền dữ liệu
    @Published var phanLoai = ""
    @Published var loai = ""
    @Published var khoNhan = ""
    @Published var LoaiHang = ""
    @Published var slTon = 0
    @Published var slXuat = 0
    @Published var NgayXuat = ""
    @Published var NgayTra = ""
    @Published var MaNv = ""
    @Published var TenNv = ""
    @Published var SDT = ""
    @Published var LyDo = ""
    
    // Các lựa chọn
    @Published var listLuaChon = ["Nhập kho","Cho mượn"]
    @Published var ListLoaiHang = ["Hàng mới","Hàng tái sử dụng"]
    
    //  Các biến lưu dữ liệu API
    @Published var data: MasterGoodData?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    
    // Danh sách kho
    @Published var ListStock: [FactoryData]? = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Lấy thông tin trong kho
    func getPhanLoaiAPI(stockName: String, code: String){
        isLoading = true
        errorMessage = nil
       let code = "DV-HVT01"
        guard let url = URL(string: ApiLink.shared.MasterByCode+"/\(stockName)/\(code)")else{
            errorMessage = "URL không hợp lệ"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: MasterGoodAloneModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        self?.data = response.data
                        self?.isLoading = true
                    } else {
                        self?.errorMessage = response.message ?? "Lỗi khi lấy dữ liệu kho"
                    }
                }
            )
            .store(in: &cancellables)
    }
    //  Lấy danh sách kho
    func getListFactory(section: String){
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.getStockBySection+"?sectionControl=\(section)") else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ListFactoryModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        self?.ListStock = response.data
                        self?.isLoading = true
                    } else {
                        self?.errorMessage = response.message ?? "Lỗi khi lấy dữ liệu kho"
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    
    // Reset
    func ResetFrom(){
        phanLoai = ""
        loai = ""
        khoNhan = ""
        LoaiHang = ""
        slTon = 0
        slXuat = 0
        NgayXuat = ""
        NgayTra = ""
        MaNv = ""
        TenNv = ""
        SDT = ""
        LyDo = ""
    }
}
