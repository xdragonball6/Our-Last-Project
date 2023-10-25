//
//  ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/16/23.
//

import UIKit

import Firebase

class HomeViewController: UIViewController, UIScrollViewDelegate{

    // scrollView
  
    // pageControl

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    @IBOutlet weak var MainBtnCollectionView: UICollectionView!
    
    
    
    var images: [UIImage] = [] // 이미지를 저장할 배열
        let imageUrls = ["https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.34.png?alt=media&token=feced1e3-7ad5-4324-a8db-94d10d9543cb&_gl=1*1a46l0v*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY4OTYuNDAuMC4w","https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.55.png?alt=media&token=12598f0b-c148-46dd-b34d-d392eebc27e1&_gl=1*we5xib*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY5OTIuNS4wLjA.",  "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.53.29.png?alt=media&token=6b6a6078-2059-433b-8149-4c7dc8011f9a&_gl=1*ip4yv0*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTcwMTIuNDkuMC4w"]
    
    var currentPage = 0
    var timer: Timer?
    var mainPageData: [FirebaseMainPageBtnModel] = []
    var firebaseMainPageBtn: FirebaseMainPageBtn = FirebaseMainPageBtn()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startImageAutoScroll()
        downloadImages()
        firebaseMainPageBtn.MainpageImageBtn()

        // CollectionView의 데이터 소스와 대리자를 현재 뷰 컨트롤러로 설정
        MainBtnCollectionView.dataSource = self
        MainBtnCollectionView.delegate = self

        // 네비게이션 타이틀 이미지 다운로드 및 설정
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
    }


    
//    @IBAction func reservationBtn(_ sender: UIBarButtonItem) {
//        
//        
//        
//        
//        
//    }
    

    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    func readValues(){
        let mainbtn = FirebaseMainPageBtn()
        mainbtn.delegate = self
        mainbtn.MainpageImageBtn()
    }

       func downloadImages() {
           for imageUrl in imageUrls {
               if let url = URL(string: imageUrl) {
                   let session = URLSession.shared
                   let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                       if let error = error {
                           print("Error: \(error)")
                       } else if let data = data, let image = UIImage(data: data) {
                           self?.images.append(image)
                           DispatchQueue.main.async {
                               self?.configureScrollView()
                           }
                       }
                   }
                   task.resume()
               }
           }
       }

    func startImageAutoScroll() {
           timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
       }

       @objc func scrollToNextPage() {
           currentPage += 1
           if currentPage >= images.count {
               currentPage = 0
           }
           let contentOffsetX = scrollView.frame.size.width * CGFloat(currentPage)
           scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
       }

       func configureScrollView() {
           scrollView.isPagingEnabled = true
           scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
           scrollView.delegate = self

           for (index, image) in images.enumerated() {
               let imageView = UIImageView(frame: CGRect(x: scrollView.frame.size.width * CGFloat(index), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
               imageView.image = image
               imageView.contentMode = .scaleAspectFit
               scrollView.addSubview(imageView)
           }

           pageControl.numberOfPages = images.count
           pageControl.currentPage = 0
       }

       func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width)
           pageControl.currentPage = Int(pageIndex)
       }
   }

extension HomeViewController: FirebaseMainPageBtnProtocol{
    func itemDownloaded(items: [FirebaseMainPageBtnModel]) {
            mainPageData = items
        DispatchQueue.main.async { [weak self] in
            self?.MainBtnCollectionView.reloadData()
            print("완료")
        }
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(mainPageData.count)
        return mainPageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageBtnCollectionViewCell
        
        // 데이터가 비어 있는 경우
        if mainPageData.isEmpty {
            // 셀을 빈 상태로 표시하거나 다른 처리를 수행하도록 변경 가능
            cell.imgMainPageBtn.image = nil
            cell.lblMainPageBtn.text = ""
        } else {
            let data = mainPageData[indexPath.item]
            // 이미지 다운로드 및 설정
            if let imageURL = URL(string: data.image) {
                URLSession.shared.dataTask(with: imageURL) { (imageData, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                    } else if let imageData = imageData, let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            cell.imgMainPageBtn.image = image
                            cell.lblMainPageBtn.text = data.name
                        }
                    }
                }.resume()
            }
        }
        
        return cell
    }
}
