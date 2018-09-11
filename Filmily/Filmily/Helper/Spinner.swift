//
//  Spinner.swift
//  Filmily
//
//  Created by Azules on 2018/9/11.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    
    open static func start() {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.activityIndicatorViewStyle = .white
            
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    open static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    
}
