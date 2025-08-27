//
//  MasterGoodViewModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//
import Foundation
import Combine
class MasterGoodViewModel: ObservableObject{
    @Published var phanloai: [MasterGoodData]? = []
    @Published var data: MasterGoodDataSL?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    
    
    private var cancellables: Set<AnyCancellable> = []
    // lấy thông tin danh sách lựa chọn
    func fetchMasterGood(section: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // Encode các tham số để tránh lỗi URL
        guard let encodedCode = section.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: ApiLink.shared.MasterGoodBySection + "?sectionControl=\(encodedCode)") else {
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
            .decode(type: MasterGoodModel.self, decoder: JSONDecoder())
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
                        print("API Error: \(error)")
                        completion(false)
                    }
                },
                receiveValue: { [weak self] response in
                    if response.success {
                        self?.phanloai = response.data
                        self?.isLoading = false
                        completion(true)
                    } else {
                        self?.errorMessage = response.message ?? "Không tìm thấy dữ liệu phân loại"
                        completion(false)
                    }
                }
            )
            .store(in: &cancellables)
    }
    // lấy thông tin khi quét mã
    func getMasterByCode(stockName: String, code: String, completion: @escaping (Bool) -> Void) {
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
                        self?.isLoading = false
                        completion(true)
                    } else {
                        self?.errorMessage = response.message ?? "Không tìm thấy dữ liệu phân loại"
                        completion(false)
                    }
                }
            )
            .store(in: &cancellables)
    }
    // import thông tin nhập kho
    func importUsedGoods(request: ImportUsedGoodsRequest, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: ApiLink.shared.importUsedgood) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        if request.nvchR_REASON_IN_OUT == "" {
            errorMessage = "Không được bỏ trống lý do"
            isLoading = false
            completion(false)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            errorMessage = "Lỗi khi tạo dữ liệu gửi đi"
            isLoading = false
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self?.errorMessage = "Lỗi từ server"
                    completion(false)
                    return
                }
                
                self?.isSuccess = true
                completion(true)
            }
        }.resume()
    }
}
