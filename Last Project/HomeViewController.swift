//
//  ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/16/23.
//

import UIKit

import Firebase

class HomeViewController: UIViewController, UIScrollViewDelegate {

    // scrollView
  
    // pageControl

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var images: [UIImage] = [] // 이미지를 저장할 배열
        let imageUrls = ["https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.34.png?alt=media&token=feced1e3-7ad5-4324-a8db-94d10d9543cb&_gl=1*1a46l0v*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY4OTYuNDAuMC4w","https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.55.png?alt=media&token=12598f0b-c148-46dd-b34d-d392eebc27e1&_gl=1*we5xib*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY5OTIuNS4wLjA.",  "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.53.29.png?alt=media&token=6b6a6078-2059-433b-8149-4c7dc8011f9a&_gl=1*ip4yv0*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTcwMTIuNDkuMC4w"]
    
    var currentPage = 0
    var timer: Timer?

    override func viewDidLoad() {
           super.viewDidLoad()
           startImageAutoScroll()
           downloadImages()
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
           // 타이머 10초
           timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
       }

       @objc func scrollToNextPage() {
           // 마지막 페이지로 오면 다시 첫 페이지로 이동
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



