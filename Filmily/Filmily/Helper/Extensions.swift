//
//  Extensions.swift
//  Filmily
//
//  Created by Azules on 2018/9/11.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    
    public static func customAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = UIColor.viewFlipsideBackground()
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                             NSAttributedStringKey.font: UIFont.init(name: "MarkerFelt-Wide", size: 20.0)!]
    }
    
}

public extension UIColor {
    
    public static func viewFlipsideBackground() -> UIColor {
        return UIColor(red: 24/255.0, green: 25/255.0, blue: 27/255.0, alpha: 1.0)
    }
    
    public static func buttonRed() -> UIColor {
        return UIColor(red: 242/255.0, green: 45/255.0, blue: 94/255.0, alpha: 0.8)
    }
}

public extension UITableViewCell {
    
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
    
}
