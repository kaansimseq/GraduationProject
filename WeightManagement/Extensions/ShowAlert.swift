//
//  ShowAlert.swift
//  WeightManagement
//
//  Created by Kaan Şimşek on 28.03.2024.
//

import Foundation
import SwiftUI

extension View {
    func showAlert(title: String, message: String) {
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
