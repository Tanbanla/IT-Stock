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
    @Published var slTon = "0"
    @Published var slXuat = ""
    @Published var NgayXuat = ""
    @Published var NgayTra = ""
    @Published var MaNv = ""
    @Published var TenNv = ""
    @Published var SectionNv = ""
    @Published var SDT = ""
    @Published var LyDo = ""
    @Published var IdGood = 0
    @Published var TongSl = 0
    
    @Published var slTra = ""
    
    // Các lựa chọn
    @Published var listLuaChon = ["Xuất kho","Cho mượn"]
    @Published var ListLoaiHang = ["Hàng mới","Hàng tái sử dụng"]
    
    //  Các biến lưu dữ liệu API
    @Published var data: MasterGoodDataSL?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var dataUser: UserInforData?
    
    // Danh sách kho
    @Published var ListStock: [FactoryData]? = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Lấy thông tin trong kho
    func getPhanLoaiAPI(stockName: String, code: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        // Encode các tham số để tránh lỗi URL
        guard let encodedStockName = stockName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let encodedCode = code.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: ApiLink.shared.MasterByCode + "/\(encodedStockName)/\(encodedCode)") else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("API URL: \(url.absoluteString)") // Debug URL
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    // Try to parse error message from response
                    if let errorString = String(data: output.data, encoding: .utf8) {
                        throw NSError(domain: "", code: httpResponse.statusCode,
                                      userInfo: [NSLocalizedDescriptionKey: "Server error: \(errorString)"])
                    } else {
                        throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
                    }
                }
                
                return output.data
            }
            .decode(type: MasterGoodAloneModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    
                    switch completionResult {
                    case .finished:
                        // Completion will be handled in receiveValue
                        break
                    case .failure(let error):
                        self?.errorMessage = "Lỗi: \(error.localizedDescription)"
                        self?.isSuccess = false
                        print("API Error: \(error)")
                        completion(false)
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        if response.data == nil {
                            self?.errorMessage = "Không tìm thấy dữ liệu phân loại trong kho đã chọn \(stockName)"
                            completion(false)
                        }else{
                            self?.data = response.data
                        }
                        completion(true)
                    } else {
                        self?.errorMessage = response.message ?? "Không tìm thấy dữ liệu phân loại"
                        completion(false)
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
    
    // lấy thông tin User
    func getUserInforData(employeeID: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        // Encode employeeID để tránh lỗi URL
        guard let encodedEmployeeID = employeeID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: ApiLink.shared.UserAdidOrID + "?adidOrEmployeeId=\(encodedEmployeeID)") else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    // Nếu status code không thành công, thử parse error message
                    if let errorString = String(data: output.data, encoding: .utf8) {
                        throw NSError(domain: "", code: httpResponse.statusCode,
                                      userInfo: [NSLocalizedDescriptionKey: "Server error: \(errorString)"])
                    } else {
                        throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
                    }
                }
                
                return output.data
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        print("API Error: \(error)")
                        completion(false)
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        self?.dataUser = response.data
                        //self?.isSuccess = true
                        completion(true)
                    } else {
                        self?.errorMessage = response.message ?? "Không tìm thấy thông tin người dùng"
                        completion(false)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // Phân func Mượn or Xuất
    func MuonOrXuat(stock: String, adid: String, SectionAdid: String,completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        if loai == "Xuất kho"{
            XuatStock(stock: stock, adid: adid, SectionAdid: SectionAdid) { success in
                completion(success)
            }
        }else if loai == "Cho mượn"{
            MuonStock(stock: stock, adid: adid, SectionAdid: SectionAdid) { success in
                completion(success)
            }
        }
        
        // Mượn
        func MuonStock(stock: String, adid: String, SectionAdid: String,completion: @escaping (Bool) -> Void){
            isLoading = true
            errorMessage = nil
            isSuccess = false
            
            guard let url = URL(string: ApiLink.shared.exportBorrowReturn) else {
                errorMessage = "URL không hợp lệ"
                isLoading = false
                completion(false)
                return
            }
            var typeGood = ""
            if LoaiHang == "Hàng mới" {
                typeGood = "N"
            }else{
                typeGood = "R"
            }
            
            let xuat = convertDateFormat(from: NgayXuat)
            let tra = convertDateFormat(from: NgayTra)
            
            let requesBody = BorrowData(iD_GOODS: IdGood, nvchR_ITEM_NAME: phanLoai, chR_KHO: stock, chR_KIND_IN_OUT: "L", chR_TYPE_GOODS: typeGood, inT_QTY_IN_OUT: Int(slXuat), inT_QTY_IN_STOCK: nil, dtM_DATE_IN_OUT: xuat, chR_PER_IT: adid, chR_SECT: SectionNv, chR_PER_SECT: TenNv, chR_CODE_PER_SECT: MaNv, nvchR_EQUIP_NAME: nil, nvchR_REASON_IN_OUT: LyDo, chR_USER_UPDATE: adid, chR_KHO_NHAN: khoNhan, vchR_BORROWER_PHONE_NUMBER: SDT, dtM_EXPECTED_RETURN_DATE: tra, id: nil, nvchR_RETURNER: nil, vchR_CODE_RETURNER: nil, vchR_RETURNER_PHONE_NUMBER: nil, inT_QUANTITY_RETURN: nil, dtM_RETURN_DATE: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(requesBody)
                request.httpBody = jsonData
            } catch {
                errorMessage = "Error encoding JSON: \(error)"
                isLoading = false
                completion(false)
                return
            }
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let httpResponse = output.response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .decode(type: ReturnData.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completionResult in
                    self?.isLoading = false
                    switch completionResult {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        completion(false)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] response in
                    if response.success {
                        self?.isLoading = false
                        self?.isSuccess = true
                        completion(false)
                    } else {
                        self?.errorMessage = response.message ?? "Xuất kho thất bại"
                        completion(false)
                    }
                }
                .store(in: &cancellables)
        }
    }
    // Xuất
    func XuatStock(stock: String, adid: String, SectionAdid: String,completion: @escaping (Bool) -> Void){
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.exportBorrowReturn) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        var typeGood = ""
        if LoaiHang == "Hàng mới" {
            typeGood = "N"
        }else{
            typeGood = "R"
        }
        
        let xuat = convertDateFormat(from: NgayXuat)
        
        let requesBody = BorrowData(iD_GOODS: IdGood, nvchR_ITEM_NAME: phanLoai, chR_KHO: stock, chR_KIND_IN_OUT: "O", chR_TYPE_GOODS: typeGood, inT_QTY_IN_OUT: Int(slXuat), inT_QTY_IN_STOCK: nil, dtM_DATE_IN_OUT: xuat, chR_PER_IT: adid, chR_SECT: SectionNv, chR_PER_SECT: TenNv, chR_CODE_PER_SECT: MaNv, nvchR_EQUIP_NAME: nil, nvchR_REASON_IN_OUT: LyDo, chR_USER_UPDATE: adid, chR_KHO_NHAN: khoNhan, vchR_BORROWER_PHONE_NUMBER: nil, dtM_EXPECTED_RETURN_DATE: nil, id: nil, nvchR_RETURNER: nil, vchR_CODE_RETURNER: nil, vchR_RETURNER_PHONE_NUMBER: nil, inT_QUANTITY_RETURN: nil, dtM_RETURN_DATE: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(requesBody)
            request.httpBody = jsonData
        } catch {
            errorMessage = "Error encoding JSON: \(error)"
            isLoading = false
            completion(false)
            return
        }
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ReturnData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionResult in
                self?.isLoading = false
                switch completionResult {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                if response.success {
                    self?.isLoading = false
                    self?.isSuccess = true
                    completion(false)
                } else {
                    self?.errorMessage = response.message ?? "Xuất kho thất bại"
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    // Tra
    func TraStock(stock: String, adid: String,item: ListBorrowData?,completion: @escaping (Bool) -> Void){
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.exportBorrowReturn) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        var typeGood = ""
        if LoaiHang == "Hàng mới" {
            typeGood = "N"
        }else{
            typeGood = "R"
        }// Cần xác nhận vchR_BORROW_CODE
        let requesBody = BorrowData(iD_GOODS: Int(item?.iD_GOODS ?? "0"), nvchR_ITEM_NAME: phanLoai, chR_KHO: item?.chR_KHO, chR_KIND_IN_OUT: "R", chR_TYPE_GOODS: typeGood, inT_QTY_IN_OUT: item?.inT_QTY_IN_OUT, inT_QTY_IN_STOCK: item?.inT_QTY_IN_STOCK, dtM_DATE_IN_OUT: item?.dtM_DATE_IN_OUT, chR_PER_IT: item?.chR_PER_IT, chR_SECT: item?.chR_SEC, chR_PER_SECT: item?.chR_PER_SECT, chR_CODE_PER_SECT: item?.chR_CODE_PER_SECT, nvchR_EQUIP_NAME: nil, nvchR_REASON_IN_OUT: LyDo, chR_USER_UPDATE: adid, chR_KHO_NHAN: khoNhan, vchR_BORROWER_PHONE_NUMBER: item?.vchR_BORROWER_PHONE_NUMBER, dtM_EXPECTED_RETURN_DATE: item?.dtM_EXPECTED_RETURN_DATE, id: item?.id, nvchR_RETURNER: TenNv, vchR_CODE_RETURNER: MaNv, vchR_RETURNER_PHONE_NUMBER: SDT, inT_QUANTITY_RETURN: Int(slTra), dtM_RETURN_DATE: NgayTra)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(requesBody)
            request.httpBody = jsonData
        } catch {
            errorMessage = "Error encoding JSON: \(error)"
            isLoading = false
            completion(false)
            return
        }
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ReturnData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completionResult in
                self?.isLoading = false
                switch completionResult {
                case .failure(let error):
                    self?.isSuccess = false
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                if response.success {
                    self?.isLoading = false
                    self?.isSuccess = true
                    completion(false)
                } else {
                    self?.isSuccess = false
                    self?.errorMessage = response.message ?? "Xuất kho thất bại"
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    // formart dd/MM/yyyy to yyyy-MM-dd
    func convertDateFormat(from input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    // Reset
    func ResetFrom(){
        phanLoai = ""
        loai = ""
        khoNhan = ""
        LoaiHang = ""
        slTon = "0"
        slXuat = ""
        //NgayXuat = ""
        //NgayTra = ""
        MaNv = ""
        TenNv = ""
        SectionNv = ""
        SDT = ""
        LyDo = ""
        
        //reset trả
        slTra=""
        // reset tim kiem api
        data = nil
        isLoading = false
        isSuccess = false
        errorMessage = nil
        dataUser = nil
    }
}
