//
//  KakaoAuthVM.swift
//  Last Project
//
//  Created by 박지환 on 10/19/23.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool = false
    
    @Published var profileImageURL: String?
    @Published var thumbnailImageURL: String?
    
    lazy var loginStatusInfo : AnyPublisher<String?, Never> = $isLoggedIn.compactMap{ $0 ? "로그인 상태" : "로그아웃 상태" }.eraseToAnyPublisher()
    
    init() {
        print("kakaoAuthVM - init() called")
    }
    
    // 카카오톡 앱으로 로그인 인증
    func kakaoLoginwithApp() async -> Bool{
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    func kakaoLoginWithAccount() async -> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func KakaoLogin(){
        print("KakaoAuthVM - handleKakaoLogin() called")
        Task{
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 앱으로 로그인 인증
                isLoggedIn = await kakaoLoginwithApp()
            }else{ // 카톡이 설치가 안되어 있으면
                // 카카오 계정으로 로그인
                isLoggedIn = await kakaoLoginWithAccount()
            }
            // 사용자 정보 가져오기
            let (name, profileImageURL, thumbnailImageURL) = await fetchKakaoUserInfo()
            if let name = name,  let profileImageURL = profileImageURL, let thumbnailImageURL = thumbnailImageURL{
                // 사용자 정보를 처리하는 코드 추가
                // 이 예시에서는 콘솔에 출력합니다.
                print("User Name: \(name), User profileImageURL: \(profileImageURL), User thumbnailImageURL: \(thumbnailImageURL)")
            }
        }
    }// login
    
    @MainActor
    func kakaoLogout(){
        Task {
            if await handlekakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    
    func handlekakaoLogout() async -> Bool{
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func fetchKakaoUserInfo() async -> (String?, String?, String?) {
        return await withCheckedContinuation { continuation in
            UserApi.shared.me { [self] user, error in
                if let error = error {
                    print(error)
                    continuation.resume(returning: (nil, nil, nil))
                } else {
                    guard let name = user?.kakaoAccount?.profile?.nickname else {
                        print("name is nil")
                        continuation.resume(returning: (nil, nil, nil))
                        return
                    }
                    let profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
                    let thumbnailImageURL = user?.kakaoAccount?.profile?.thumbnailImageUrl?.absoluteString
                    continuation.resume(returning: (name, profileImageURL, thumbnailImageURL))
                }
            }
        }
    }
    
    
    
    
    
    
}
