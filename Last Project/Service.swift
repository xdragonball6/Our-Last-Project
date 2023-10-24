//
//  Service.swift
//  Last Project
//
//  Created by 박지환 on 10/24/23.
//

import Foundation
import UIKit

class Service {
    static func createAlertController(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
}
