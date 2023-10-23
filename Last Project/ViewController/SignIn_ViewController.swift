//
//  SignIn_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/20/23.
//

import UIKit
import Firebase
import FirebaseAuth
class SignIn_ViewController: UIViewController {

    // 텍스트 필드
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfPW: UITextField!
    @IBOutlet weak var tfPW_Twice: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    // 버튼정리
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnAll2: UIButton!
    @IBOutlet weak var btnOver: UIButton!
    @IBOutlet weak var btnOver2: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnService2: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var btnPrivate2: UIButton!
    
    var first : Bool = false
    var second : Bool = false
    var third : Bool = false
    var forth: Bool = false
    
    
    @IBOutlet weak var btnAgree: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func btnAgreeAndSignIn(_ sender: UIButton) {
        let userid = tfID.text ?? ""
        let name = tfNickName.text ?? ""
        let password = tfPW.text ?? ""
        let phone = tfPhone.text ?? ""
        // 이메일 주소가 비어있지 않고 유효한 경우에만 처리 진행
            if !userid.trimmingCharacters(in: .whitespaces).isEmpty, isValidEmail(email: userid) {
                let signInModel = FirebaseSignInModel()
                
                // Firebase에서 이미 존재하는 userid를 확인하고, 존재하면 실패 메시지 표시
                signInModel.insertItems(userid: userid, name: name, password: password, phone: phone) { success in
                    if success {
                        Auth.auth().createUser(withEmail: userid, password: password) { (authResult, error) in
                            if let error = error {
                                print("Error creating user: \(error.localizedDescription)")
                                self.showErrorMessage(message: "이미 존재하는 이메일 주소 또는 회원가입 중에 오류가 발생했습니다")
                            } else if let user = authResult?.user {
                                print(user)
                                self.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "sgSignIn", sender: nil)
                            }
                        }
                    } else {
                        self.showErrorMessage(message: "이미 존재하는 이메일 주소 또는 회원가입 중에 오류가 발생했습니다")
                    }
                }
            } else {
                showErrorMessage(message: "올바른 이메일 주소를 입력해주세요")
            }
        }

        func showErrorMessage(message: String) {
            let resultAlert = UIAlertController(title: "실패", message: message, preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true)
        }

        // Email 주소 형태를 확인하는 함수
        func isValidEmail(email: String) -> Bool {
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    
    // 버튼 액션 정리
    
    @IBAction func btnAllChange(_ sender: UIButton) {
        if first == false{
            first = true
        }else{
            first = false
        }
        changeAll()
    }
    
    func changeAll(){
        if first == true{
            second = true
            third = true
            forth = true
            changeColor()
        }else{
            second = false
            third = false
            forth = false
            changeColor()
        }
    }
    
    func changeColor(){
        if first == true{
            btnAll.tintColor = .red
            btnOver.tintColor = .red
            btnService.tintColor = .red
            btnPrivate.tintColor = .red
            btnAgree.isEnabled = true
        }else{
            btnAgree.isEnabled = false
        }
        if second == true{
            btnOver.tintColor = .red
        }else{
            btnOver.tintColor = .lightGray
        }
        if third == true{
            btnService.tintColor = .red
        }else{
            btnService.tintColor = .lightGray
        }
        if forth == true{
            btnPrivate.tintColor = .red
        }else{
            btnPrivate.tintColor = .lightGray
        }
        if second == true && third == true && forth == true{
            first = true
            btnAll.tintColor = .red
            btnAgree.isEnabled = true
        }else{
            first = false
            btnAll.tintColor = .lightGray
            btnAgree.isEnabled = false
        }
    }
    
    
    @IBAction func btnOverAge(_ sender: UIButton) {
        if second == false{
            second = true
        }else{
            second = false
        }
        changeColor()
    }
    
    
    @IBAction func btnServiceAgree(_ sender: UIButton) {
        if third == false{
            third = true
        }else{
            third = false
        }
        changeColor()
    }
    
    
    @IBAction func btnPrivateAgree(_ sender: UIButton) {
        if forth == false{
            forth = true
        }else{
            forth = false
        }
        changeColor()
    }
    
    
    
    
    
    
    
    // keyboard 세팅
    func setKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y = -50 //키보드가 나타나면서 어디까지 나타날지 y의 값을 나타내는 녀석
    }
    
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0 // y좌표를 0으로 돌려 원래 화면 나오게 하기
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
            }
    
    
    
    
}
