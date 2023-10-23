//
//  KakaoUserResponse.swift
//  Last Project
//
//  Created by 박지환 on 10/23/23.
//

import Foundation
struct KakaoUserResponse: Codable {
    let connectedAt: String
    let id: Int
    let kakaoAccount: KakaoAccount
    let properties: [String: String]

    struct KakaoAccount: Codable {
        let profile: Profile

        struct Profile: Codable {
            let isDefaultImage: Int
            let nickname: String
            let profileImageUrl: String
            let thumbnailImageUrl: String
        }
    }
}
