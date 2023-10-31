//
//  LogIn_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/19/23.
//

import UIKit
import SnapKit
import Combine
class LogIn_ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    
    @IBOutlet weak var kakaoLoginStatuslabel: UILabel!
    
    @IBOutlet weak var BarItem: UITabBarItem!
    
    
    @IBOutlet weak var btn_KAKAO_LogIN: UIButton!
    
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM()} ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        kakaoLoginStatuslabel.isHidden = true
    }
    

    
    @IBAction func btn_KAKAO_Login(_ sender: UIButton) {
        kakaoAuthVM.KakaoLogin { [weak self] success in
                if success {
                    if SignIn.logIn_Out {
                        let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
                        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
                        let myPageImage = UIImage(systemName: "person.fill", withConfiguration: config)
                        let resultAlert = UIAlertController(title: "결과", message: "로그인 되었습니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "네", style: .default, handler: { ACTION in 
                        if let myPageNavController = myPageStoryboard.instantiateInitialViewController() as? UINavigationController {
                            myPageNavController.tabBarItem = UITabBarItem(title: "My Page", image: myPageImage, tag: 0)
                            if let tabBarController = self?.tabBarController {
                                if var viewControllers = tabBarController.viewControllers {
                                    viewControllers[2] = myPageNavController
                                    tabBarController.setViewControllers(viewControllers, animated: false)
                                }
                            }
                        }
                    })
                        resultAlert.addAction(okAction)
                        self!.present(resultAlert, animated: true)
                    }
                }
            }
        }
    	
    
//    @IBAction func btn_KAKAO_Logout(_ sender: UIButton) {
//        kakaoAuthVM.kakaoLogout()
//    }
    
    
    


    
    
    
    
}// LogIn_ViewController

// MARK: - 뷰모델 바인딩
extension LogIn_ViewController {
    fileprivate func setBindings(){
//        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
//            guard let self = self else { return }
//            self.kakaoLoginStatuslabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
//        }
//        .store(in: &subscriptions)
        self.kakaoAuthVM.loginStatusInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: self.kakaoLoginStatuslabel)
            .store(in: &subscriptions)
    }
}






#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        LogIn_ViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider {
    static var previews: some View{
        ViewControllerPresentable()
    }
}

#endif
