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
    @Published var data: MasterGoodData?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    
    
    private var cancellables: Set<AnyCancellable> = []
    // lấy thông tin danh sách lựa chọn
    func fetchMasterGood(section: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: ApiLink.shared.MasterGoodBySection+"?sectionControl=\(section)")else{
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
            .decode(type: MasterGoodModel.self, decoder: JSONDecoder())
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
                        self?.phanloai = response.data
                        self?.isLoading = true
                    } else {
                        self?.errorMessage = response.message ?? "Lỗi khi lấy dữ liệu kho"
                    }
                }
            )
            .store(in: &cancellables)
    }
    // lấy thông tin khi quét mã
    func getMasterByCode(stockName: String, code: String,completion: @escaping () -> Void){
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
