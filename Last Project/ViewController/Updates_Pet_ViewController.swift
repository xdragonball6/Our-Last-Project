//
//  Update_Pet_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/30/23.
//

import UIKit

class Updates_Pet_ViewController: UIViewController {

    var receivedname: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedname)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print(receivedname)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
