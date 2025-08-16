//
//  UserLoginController.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//

import Foundation
class LoginController: ObservableObject{
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var userData: LoginResponse.UserData?
    
    private let loginUrl = ApiLink.shared.login
    
    func login(adid: String, password: String, completion: @escaping (Bool) -> Void){
        guard !adid.isEmpty, !password.isEmpty else{
            errorMessage = "Vui lòng nhập ADID và mật khẩu"
            completion(false)
            return
        }
        isLoading = true
        errorMessage = nil
        
        let requestbody = LoginRequest(userADID: adid, password: password)
        
        guard let url = URL(string: loginUrl)else{
            errorMessage = "Url không hợp lệ"
            completion(false)
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONEncoder().encode(requestbody)
        }catch{
            errorMessage = "Lỗi khi tạo dữ liệu đăng nhập"
            isLoading =  false
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request){ [weak self] data, response, error in
            DispatchQueue.main.sync {
                self?.isLoading = false
                
                if let error = error{
                    self?.errorMessage = "Lỗi kết nối \(error.localizedDescription)"
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...209).contains(httpResponse.statusCode),
                      let data = data else{
                    self?.errorMessage = "Lỗi từ server (Mã lỗi: \((response as? HTTPURLResponse)?.statusCode ?? 0))"
                    completion(false)
                    return
                }
                
                do{
                    let loginReponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    if loginReponse.success{
                        self?.userData = loginReponse.data
                        self?.isLoading = true
                        completion(true)
                    }else{
                        self?.errorMessage = loginReponse.message
                        completion(false)
                    }
                }catch{
                    self?.errorMessage = "Lỗi khi phân tích phản hồi từ server"
                    completion(false)
                }
            }
        }.resume()
    }
    
}
