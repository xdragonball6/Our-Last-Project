//
//  dogVM.swift
//  Last Project
//
//  Created by 박지환 on 10/25/23.
//

import Foundation
protocol DogProtocol{
    func itemDownloaded(item: [dogModel])
}

class DogQueryModel{
    var delegate: DogProtocol!
    func fetchDataFromAPI(userid: String) {
        let PORT = Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? ""
        let HOST = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String ?? ""
        // API 엔드포인트 URL
        let apiUrl = "\(HOST):\(PORT)/movie/cast/\(userid)"
        var locations: [dogModel] = []
        // task 변수를 클로저 외부에서 선언
        let task = URLSession.shared.dataTask(with: URL(string: apiUrl)!) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 응답 데이터가 있는지 확인
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                // JSON 디코딩
                let decoder = JSONDecoder()
                let dogDatas = try decoder.decode(dogData.self, from: data)
                // 필요한 작업을 수행하세요
                for dog in dogDatas.result {
                    let query = dogModel(userid: dog.userid, dog_name: dog.dog_name, species: dog.species, dog_image: dog.dog_image)
                    locations.append(query)
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.delegate.itemDownloaded(item: locations)
            }
        }
        // task 시작
        task.resume()
    }
}

