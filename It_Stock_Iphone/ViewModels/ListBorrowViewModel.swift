//
//  ListBorrowViewModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 21/8/25.
//

import Combine
import Foundation

class ListBorrowViewModel: ObservableObject{
    @Published var show: Bool = false
    
    // thong tin check API
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var listBorrow : [ListBorrowData]?
    private var cancellables: Set<AnyCancellable> = []
    
    
    // lay data danh sach thiet bij cho muon
    func getListBorrow(section: String,completion: @escaping (Bool) -> Void){
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: ApiLink.shared.listBorrowNotReturn) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            completion(false)
            return
        }
        
        let requestBody = BorrowListRequest(
            chR_KHO: "ALL",
            chR_SEC_CONTROL: section,
            iS_SEARCH: false,
            date_From: "1753-01-01",
            date_To: "9998-12-31"
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            // Debug: in ra JSON để kiểm tra
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
        } catch {
            errorMessage = "Lỗi mã hóa JSON: \(error.localizedDescription)"
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
            .decode(type: ListBorrowModel.self, decoder: JSONDecoder())
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
                    self?.listBorrow = response.data
                    self?.isLoading = false
                    self?.isSuccess = true
                    completion(false)
                } else {
                    self?.errorMessage = response.message ?? "Lấy thông tin thất bại"
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
}
