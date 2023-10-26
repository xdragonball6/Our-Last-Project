//
//  FindPassword_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/24/23.
//

import UIKit
import Firebase
class FindPassword_ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
//        let findId = UITapGestureRecognizer(target: self, action: #selector(clickPoint))
//        lblfindId.isUserInteractionEnabled = true
//        lblfindId.addGestureRecognizer(findId)
        
    }
    
    //라벨 클릭으로 넘기려고 했지만 왜인지 안넘어가니까 포기
//    @objc func clickPoint(sender: UITapGestureRecognizer){
//            print("clickPoint")
//        // Instantiate the FindID_ViewController from your storyboard
//        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
//        if let webViewVC = storyboard.instantiateViewController(identifier: "FindID_ViewController") as? FindID_ViewController{
//        self.present(webViewVC, animated: true, completion: nil)
//                }
//        }
    
    
    @IBAction func forgotPrassButton_Tapped(_ sender: UIButton) {
        let email = emailField.text
        let name = nameField.text
        let phone = phoneField.text
        
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        usersRef.whereField("userid", isEqualTo: email as Any)
            .whereField("name", isEqualTo: name!)
            .whereField("phone", isEqualTo: phone!)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    // 처리 중 오류가 발생했을 때 처리
                    let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        // 사용자가 일치하는 경우 비밀번호 재설정 이메일을 보냅니다.
                        let auth = Auth.auth()
                        auth.sendPasswordReset(withEmail: email!) { (error) in
                            if let error = error {
                                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let resultAlert = UIAlertController(title: "링크 전송 완료", message: "등록된 이메일에서 비밀번호 재설정요청 링크를 확인해주세요", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "확인", style: .default, handler: {
                                    ACTION in self.navigationController?.popViewController(animated: true)
                                })
                                resultAlert.addAction(okAction)
                                self.present(resultAlert, animated: true)
                            }
                        }
                    } else {
                        // 사용자가 일치하지 않는 경우 처리
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
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if !newText.isEmpty {
                btnSend.isEnabled = true // 텍스트가 비어 있지 않으면 버튼 활성화
            } else {
                btnSend.isEnabled = false // 텍스트가 비어 있으면 버튼 비활성화
            }
            return true
        }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
            }
    
    func setKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y = -250 //키보드가 나타나면서 어디까지 나타날지 y의 값을 나타내는 녀석
        self.navigationItem.titleView?.alpha = 0.0
    }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0 // y좌표를 0으로 돌려 원래 화면 나오게 하기
    }

}
