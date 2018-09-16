//
//  Alertable.swift
//  Filmily
//
//  Created by Azules on 2018/9/15.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.present(alertController, animated: true, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}
