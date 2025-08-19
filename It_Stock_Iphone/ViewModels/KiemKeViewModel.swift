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
    
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
}
