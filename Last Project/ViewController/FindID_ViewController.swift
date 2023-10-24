//
//  FindID_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/24/23.
//

import UIKit
import Firebase
class FindID_ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        phoneField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func forgotPrassButton_Tapped(_ sender: UIButton) {
        let name = nameField.text
        let phone = phoneField.text
        
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        usersRef.whereField("name", isEqualTo: name!)
                .whereField("phone", isEqualTo: phone!)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let document = querySnapshot?.documents.first {
                            let userID = document["userid"] as? String
                            if let userID = userID {
                                // 사용자가 일치하는 경우 userID를 사용할 수 있습니다.
                                let resultAlert = UIAlertController(title: "사용자의 ID", message: "\(userID)", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "확인", style: .default, handler: {
                                    ACTION in self.navigationController?.popViewController(animated: true)
                                    self.navigationController?.popViewController(animated: true)
                                })
                                resultAlert.addAction(okAction)
                                self.present(resultAlert, animated: true)
                            } else {
                                let alert = Service.createAlertController(title: "Error", message: "UserID not found.")
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            let alert = Service.createAlertController(title: "Error", message: "User not found.")
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
    

    // UITextFieldDelegate 메서드
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 이 메서드는 텍스트가 변경될 때 호출됩니다.
            // 라벨 텍스트에 따라 버튼을 활성화 또는 비활성화합니다.
            let newText = (textField.text as! NSString).replacingCharacters(in: range, with: string)
            if !newText.isEmpty {
                btnSend.isEnabled = true // 텍스트가 비어 있지 않으면 버튼 활성화
            } else {
                btnSend.isEnabled = false // 텍스트가 비어 있으면 버튼 비활성화
            }
            return true
        }
    
}
