//
//  LogIn_with_Email_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/20/23.
//

import UIKit
import FirebaseAuth
class LogIn_with_Email_ViewController: UIViewController {

    
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    var id = ""
    var pw = ""
    
    
    @IBOutlet weak var nvTitle: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func btnLogIN(_ sender: UIButton) {
        let email: String = tfID.text!.description
            let pw: String = tfPassword.text!.description
            Auth.auth().signIn(withEmail: email, password: pw) { authResult, error in
                if error != nil {
                    // 로그인 실패
                    print("log in failed")
                    let resultAlert = UIAlertController(title: "결과", message: "해당 아이디는 존재하지 않습니다. 다시 입력해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "네", style: .default)
                    resultAlert.addAction(okAction)
                    self.present(resultAlert, animated: true)
                } else {
                    // 로그인 성공
                    print("log in")
                    
                    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
                    let myPageImage = UIImage(systemName: "person.fill", withConfiguration: config)
                    let resultAlert = UIAlertController(title: "결과", message: "로그인 되었습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "네", style: .default, handler: { ACTION in 
                        SignIn.logIn_Out = true
                        SignIn.userID = self.tfID.text!
                        if SignIn.logIn_Out {
                            let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
                            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
                            let myPageImage = UIImage(systemName: "person.fill", withConfiguration: config)
                            if let myPageNavController = myPageStoryboard.instantiateInitialViewController() as? UINavigationController {
                                myPageNavController.tabBarItem = UITabBarItem(title: "My Page", image: myPageImage, tag: 0)

                                if let tabBarController = self.tabBarController {
                                    if var viewControllers = tabBarController.viewControllers {
                                        // Assuming "LogInViewController" is at index 3 (change the index accordingly)
                                        viewControllers[3] = myPageNavController
                                        tabBarController.setViewControllers(viewControllers, animated: false)
                                    }
                                }
                            }
                        }
                    })
                    resultAlert.addAction(okAction)
                    self.present(resultAlert, animated: true)
                }
            }
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
        nvTitle.title = ""
    }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0 // y좌표를 0으로 돌려 원래 화면 나오게 하기
        nvTitle.title = "이메일 로그인"
    }
    
    
    
}
