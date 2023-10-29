//
//  MainPageReservationViewView2ViewController.swift
//  Last Project
//
//  Created by leeyoonjae on 10/30/23.
//

import UIKit

class MainPageReservationViewView2ViewController: UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    

    @IBOutlet weak var lblImage2: UIImageView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainLogo%2F%E1%84%85%E1%85%A9%E1%84%80%E1%85%A9.png?alt=media&token=1cc1d45c-5af7-43bb-8de4-c88aacd2f03a&_gl=1*1i1b2jk*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5ODI1MTQwMS45OC4xLjE2OTgyNTIyMDMuMzguMC4w") {
            URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                } else if let data = data, let image = UIImage(data: data) {
                    // 이미지 다운로드 완료 후 UI 업데이트는 메인 스레드에서 수행해야 합니다.
                    DispatchQueue.main.async {
                        // 원격 이미지를 타이틀 뷰로 설정
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = .scaleAspectFit
                        self?.navigationItem.titleView = imageView
                    }
                }
            }.resume()
        }

        lblName.text = FirebaseMainPageBtnMessage.name
        
        let image2URLString = FirebaseMainPageBtnMessage.image2
                
                if let image2URL = URL(string: image2URLString) {
                    // 이미지를 다운로드하고 이미지 뷰에 설정
                    URLSession.shared.dataTask(with: image2URL) { [weak self] (data, response, error) in
                        if let error = error {
                            print("Error downloading image: \(error)")
                        } else if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.lblImage2.image = image
                            }
                        }
                    }.resume()
                }
            }
        }


