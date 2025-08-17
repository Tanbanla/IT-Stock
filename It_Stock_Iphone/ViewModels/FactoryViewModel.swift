//
//  FactoryViewModel.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 18/8/25.
//

import Foundation
import Combine
class FactoryViewModel: ObservableObject {
    @Published var factories: [String] = []
    @Published var selectedFactory: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchFactories(section: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: ApiLink.shared.getBySection+"?sectionControl=\(section)")else{
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
            .decode(type: FactoryModel.self, decoder: JSONDecoder())
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
                        self?.factories = response.data ?? []
                    } else {
                        self?.errorMessage = response.message ?? "Lỗi khi lấy dữ liệu kho"
                    }
                }
            )
            .store(in: &cancellables)
        
    }
}
