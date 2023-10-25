//
//  CustomTabBarController.swift
//  Last Project
//
//  Created by 박지환 on 10/23/23.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
    }
}
