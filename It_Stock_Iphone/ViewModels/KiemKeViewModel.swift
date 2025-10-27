//
//  KiemKeViewModel.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 20/8/25.
//

import Foundation
import Combine

class KiemKeViewModel: ObservableObject{
    @Published var listLoaiHang = ["Hàng mới", "Hàng tái sử dụng"]
    
    @Published var LoaiHang = ""
    @Published var phanLoai = ""
    @Published var NgayKiemKe = ""
    @Published var slMax = ""
    @Published var slMin = ""
    @Published var slTon = ""
    @Published var slKiemKe = "0"
    @Published var slKiemKeM = "0"
    @Published var slLechM = "0"
    @Published var slLech = "0"
    @Published var Lydo = ""
    @Published var LydoM = ""
    @Published var HangMoi = ""
    @Published var HangTaiSuDung = ""
    
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    
    @Published var data: MasterGoodDataSL?
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
                        //self?.data = response.data
                        if response.data == nil {
                            self?.errorMessage = "Không tìm thấy dữ liệu phân loại trong kho đã chọn \(stockName)"
                            completion(false)
                        }else{
                            self?.data = response.data
                        }
                        //self?.isSuccess = true
                        completion(true)
                    } else {
                        self?.errorMessage = response.message ?? "Không tìm thấy dữ liệu phân loại"
                        completion(false)
                    }
                }
            )
            .store(in: &cancellables)
    }
    //    {
    //      "id": 0,
    //      "dtM_DATE_INVENT": "2025-08-22T07:43:52.450Z",
    //      "iD_GOODS": 0,
    //      "nvchR_ITEM_NAME": "string",
    //      "chR_KHO": "string",
    //      "inT_QTY_STOCK_SUM": 0,
    //      "inT_QTY_GOODS_NEW": 0,
    //      "inT_QTY_GOOD_NEW_INVENT": 0,
    //      "inT_QTY_DIFF_NEW": 0,
    //      "nvchR_REASON_DIFF_NEW": "string",
    
    
    //      "inT_QTY_GOODS_REUSE": 0,
    //      "inT_QTY_GOOD_REUSE_INVENT": 0,
    //      "inT_QTY_DIFF_REUSE": 0,
    //      "nvchR_REASON_DIFF_REUSE": "string",
    
    //      "dtM_DATE_UPDATE": "2025-08-22T07:43:52.450Z",
    //      "chR_USER_UPDATE": "string",
    //      "chR_USER_START_INVENT": "string",
    //      "chR_USER_SCLOSE_INVENT": "string",
    //      "dtM_END_INVENT": "2025-08-22T07:43:52.450Z",
    //      "inT_STATUS_INVENT": 0
    //    }
    
    
    //    let requesBody = InventoryBody(
    //        id: nil,
    //        dtM_DATE_INVENT: NgayKiemKe,
    //        iD_GOODS: data?.id,
    //        nvchR_ITEM_NAME: data?.nvchR_ITEM_NAME,
    //        chR_KHO: stock,
    //        inT_QTY_STOCK_SUM: Int(slTon),
    //        inT_QTY_GOODS_NEW: data?.inT_QTY_NEW,
    //        inT_QTY_GOOD_NEW_INVENT: Int(slKiemKeM),
    //        inT_QTY_DIFF_NEW: Int(slLechM),
    //        nvchR_REASON_DIFF_NEW: LydoM,
    //        inT_QTY_GOODS_REUSE: data?.inT_QTY_OLD,
    //        inT_QTY_GOOD_REUSE_INVENT: Int(slKiemKe),
    //        inT_QTY_DIFF_REUSE: Int(slLech),
    //        nvchR_REASON_DIFF_REUSE: Lydo,
    //        dtM_DATE_UPDATE: NgayKiemKe,
    //        chR_USER_UPDATE: adid,
    //        chR_USER_START_INVENT: nil,
    //        chR_USER_SCLOSE_INVENT: nil,
    //        dtM_END_INVENT: nil,
    //        inT_STATUS_INVENT: 1
    //    )
    //    // Kiểm Kê API
    func InventoryStock(stock: String, adid: String,completion: @escaping (Bool) -> Void){
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.Inventory) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        
        let requesBody = InventoryBody(
            id: 0,
            dtM_DATE_INVENT: NgayKiemKe,
            iD_GOODS: data?.id,
            nvchR_ITEM_NAME: data?.nvchR_ITEM_NAME,
            chR_KHO: stock,
            inT_QTY_STOCK_SUM: Int(slTon),
            inT_QTY_GOODS_NEW: data?.inT_QTY_NEW,
            inT_QTY_GOOD_NEW_INVENT: Int(slKiemKeM),
            inT_QTY_DIFF_NEW: Int(slLechM),
            nvchR_REASON_DIFF_NEW: LydoM,
            inT_QTY_GOODS_REUSE: data?.inT_QTY_OLD,
            inT_QTY_GOOD_REUSE_INVENT: Int(slKiemKe),
            inT_QTY_DIFF_REUSE: Int(slLech),
            nvchR_REASON_DIFF_REUSE: Lydo,
            dtM_DATE_UPDATE: NgayKiemKe,
            chR_USER_UPDATE: adid,
            chR_USER_START_INVENT: nil,
            chR_USER_SCLOSE_INVENT: nil,
            dtM_END_INVENT: nil,
            inT_STATUS_INVENT: 1
        )
        
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
            .decode(type: InventoryRespone.self, decoder: JSONDecoder())
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
                    self?.errorMessage = response.message ?? "Kiểm kê thất bại"
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    func InventoryStockM(stock: String, adid: String,completion: @escaping (Bool) -> Void){
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.Inventory) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        
        var requesBody: InventoryBody
        //        if LoaiHang == "Hàng mới" {
        requesBody = InventoryBody(id: nil, dtM_DATE_INVENT: NgayKiemKe, iD_GOODS: data?.id, nvchR_ITEM_NAME: data?.nvchR_ITEM_NAME, chR_KHO: stock, inT_QTY_STOCK_SUM: Int(slTon), inT_QTY_GOODS_NEW: data?.inT_QTY_NEW, inT_QTY_GOOD_NEW_INVENT: Int(slKiemKeM), inT_QTY_DIFF_NEW: Int(slLechM), nvchR_REASON_DIFF_NEW: LydoM, inT_QTY_GOODS_REUSE: nil, inT_QTY_GOOD_REUSE_INVENT: nil, inT_QTY_DIFF_REUSE: nil, nvchR_REASON_DIFF_REUSE: nil, dtM_DATE_UPDATE: NgayKiemKe, chR_USER_UPDATE: adid, chR_USER_START_INVENT: nil, chR_USER_SCLOSE_INVENT: nil, dtM_END_INVENT: nil, inT_STATUS_INVENT: 1)
        //        }else{
        //            requesBody = InventoryBody(id: nil, dtM_DATE_INVENT: NgayKiemKe, iD_GOODS: data?.id, nvchR_ITEM_NAME: data?.nvchR_ITEM_NAME, chR_KHO: stock, inT_QTY_STOCK_SUM: Int(slTon), inT_QTY_GOODS_NEW: nil, inT_QTY_GOOD_NEW_INVENT:nil, inT_QTY_DIFF_NEW: nil, nvchR_REASON_DIFF_NEW: nil, inT_QTY_GOODS_REUSE: data?.inT_QTY_OLD, inT_QTY_GOOD_REUSE_INVENT: Int(slKiemKe), inT_QTY_DIFF_REUSE: Int(slLech), nvchR_REASON_DIFF_REUSE: Lydo, dtM_DATE_UPDATE: NgayKiemKe, chR_USER_UPDATE: adid, chR_USER_START_INVENT: nil, chR_USER_SCLOSE_INVENT: nil, dtM_END_INVENT: nil, inT_STATUS_INVENT: 1)
        //        }
        
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
            .decode(type: InventoryRespone.self, decoder: JSONDecoder())
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
                    self?.errorMessage = response.message ?? "Kiểm kê thất bại"
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    // Reset from
    func ResetFrom(){
        phanLoai = ""
        slMax = ""
        slMin = ""
        slTon = ""
        slKiemKe = "0"
        slLech = "0"
        Lydo = ""
        HangMoi = ""
        HangTaiSuDung = ""
        slKiemKeM = "0"
        slLechM = "0"
        LydoM = ""
        
        
        isLoading = false
        isSuccess = false
        errorMessage = nil
    }
}
