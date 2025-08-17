//
//  LoginViewModel.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 17/8/25.
//
import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Input
    @Published var adid = ""
    @Published var password = ""
    @Published var showPassword = true
    
    // Output
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var currentUser: UserData?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Validation
    var isInputValid: Bool {
        !adid.isEmpty && !password.isEmpty
    }
    
    func login() {
        guard isInputValid else {
            errorMessage = "Vui lòng nhập ADID và mật khẩu"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let requestBody = LoginRequest(userADID: adid.lowercased(), password: password)
        let apiUrl = ApiLink.shared.login
        
        guard let url = URL(string: apiUrl) else {
            errorMessage = "URL không hợp lệ"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            errorMessage = "Lỗi khi tạo dữ liệu đăng nhập"
            isLoading = false
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
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                if response.success {
                    self?.currentUser = response.data
                    self?.isLoggedIn = true
                    // Lưu thông tin user hoặc token nếu cần
                    // Lưu vào UserDefaults nếu cần
                    UserDefaults.standard.set(try? JSONEncoder().encode(response.data), forKey: "currentUser")
                } else {
                    self?.errorMessage = response.message
                }
            }
            .store(in: &cancellables)
    }
    
    func reset() {
        adid = ""
        password = ""
        showPassword = false
        errorMessage = nil
    }
}
