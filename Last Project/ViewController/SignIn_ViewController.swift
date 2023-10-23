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
        if !userid.trimmingCharacters(in: .whitespaces).isEmpty{
            let signInModel = FirebaseSignInModel()
            let result = signInModel.insertItems(userid: userid, name: name, password: password, phone: phone)
            if result{
                Auth.auth().createUser(withEmail: userid, password: password) {(authResut, error) in
                            guard let user = authResut?.user else {
                                return
                            }

                            print(user)
                            self.dismiss(animated: true, completion: nil)
                        }
                let resultAlert = UIAlertController(title: "완료", message: "해당 이메일로 가입이 완료되었습니다", preferredStyle: .actionSheet)
                let onAction = UIAlertAction(title: "완료", style: .default, handler: {
                    ACTION in
                    self.performSegue(withIdentifier: "sgSignIn", sender: nil)
                })
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true)
            }else{
                    let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다", preferredStyle: .alert)
                    let onAction = UIAlertAction(title: "OK", style: .default)
                    resultAlert.addAction(onAction)
                    present(resultAlert, animated: true)
            }
        }
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
