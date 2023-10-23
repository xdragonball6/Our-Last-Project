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
    
    
    @IBOutlet weak var BarItem: UITabBarItem!
    
    
    @IBOutlet weak var btn_KAKAO_LogIN: UIButton!
    
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM()} ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
    } //viewDidLoad
    
    
    @IBAction func btn_KAKAO_Login(_ sender: UIButton) {
        kakaoAuthVM.KakaoLogin()
    }
    	
    
    //MARK: - 버튼액션
    @objc func loginBtnClicked() {
        print("loginBtnClicked() called")
        kakaoAuthVM.KakaoLogin()
    }
    
    @objc func logoutBtnClicked() {
        print("logoutBtnClicked() called")
        kakaoAuthVM.kakaoLogout()
    }

    
}// LogIn_ViewController

// MARK: - 뷰모델 바인딩
extension LogIn_ViewController {
    fileprivate func setBindings(){
        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
            guard let self = self else { return }
            
        }
        .store(in: &subscriptions)
//        self.kakaoAuthVM.loginStatusInfo
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.text. on: self.kakaoLoginStatusLabel)
//            .store(in: &subscriptions)
//        
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
