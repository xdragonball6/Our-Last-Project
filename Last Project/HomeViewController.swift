//
//  ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/16/23.
//

import UIKit

import Firebase

import FirebaseAuth

import FirebaseFirestore


class HomeViewController: UIViewController, UIScrollViewDelegate{

    // scrollView
  
    // pageControl

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    @IBOutlet weak var MainBtnCollectionView: UICollectionView!
    
    
    @IBOutlet weak var MainReservationCollectionView: UICollectionView!
    
    
    @IBOutlet weak var lblUser: UILabel!
    
    let db = Firestore.firestore()
       
       var images: [UIImage] = [] // 이미지를 저장할 배열
           let imageUrls = ["https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.34.png?alt=media&token=feced1e3-7ad5-4324-a8db-94d10d9543cb&_gl=1*1a46l0v*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY4OTYuNDAuMC4w","https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.52.55.png?alt=media&token=12598f0b-c148-46dd-b34d-d392eebc27e1&_gl=1*we5xib*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTY5OTIuNS4wLjA.",  "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/mainPage%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202023-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.53.29.png?alt=media&token=6b6a6078-2059-433b-8149-4c7dc8011f9a&_gl=1*ip4yv0*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5Nzk5NjczOS44OC4xLjE2OTc5OTcwMTIuNDkuMC4w"]
       
       var currentPage = 0
       var timer: Timer?
       // 버튼
       var mainPageData: [FirebaseMainPageBtnModel] = []
       var firebaseMainPageBtn: FirebaseMainPageBtn = FirebaseMainPageBtn()
       // 하단
       var mainPageDataDown: [FirebaseMainPageReservationListModel] = []
       var firebaseMainPageReservationList: FirebaseMainPageReservationList = FirebaseMainPageReservationList()

       
       override func viewDidLoad() {
           super.viewDidLoad()
           startImageAutoScroll()
           downloadImages()
           firebaseMainPageBtn.MainpageImageBtn()
           firebaseMainPageReservationList.delegate = self
           firebaseMainPageReservationList.MainPageReservationList()

           // 버튼 CollectionView의 데이터 소스와 대리자를 현재 뷰 컨트롤러로 설정
           MainBtnCollectionView.dataSource = self
           MainBtnCollectionView.delegate = self
           
           // 하단 CollectionView의 데이터 소스와 대리자를 현재 뷰 컨트롤러로 설정
           MainReservationCollectionView.dataSource = self
           MainReservationCollectionView.delegate = self
           
           // 유저 상태 확인
           updateUsernameLabel()

           lblUser.text = ""
           
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

    
    @IBAction func reservationBtn(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser == nil {
            // 사용자가 로그인하지 않은 경우, 알림창을 띄우고 "확인"을 누르면 로그인 화면으로 이동
            let alertController = UIAlertController(title: "비 로그인", message: "예약은 로그인 상태에서만 사용이 가능합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
                self?.showLogInScreen()
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {

        }
    }

    func showLogInScreen() {
        let logInStoryboard = UIStoryboard(name: "LogInStoryboard", bundle: nil)
        if let logInViewController = logInStoryboard.instantiateInitialViewController() {
            present(logInViewController, animated: true, completion: nil)
        }
    }






    


    
       // 로그인 했을시만 예약 번튼 클릭 가능

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 로그인 상태를 확인합니다.
        updateUsernameLabel()
        readValues()
        
        
            if let user = Auth.auth().currentUser {
                let userUID = user.uid
                print("사용자 UID: \(userUID)")
            }
    }
    
    
    func updateUsernameLabel() {
        if let user = Auth.auth().currentUser {
            if let userEmail = user.email {
                let db = Firestore.firestore()
                let userRef = db.collection("users").whereField("userid", isEqualTo: userEmail)
                
                let group = DispatchGroup()
                
                group.enter()
                
                userRef.getDocuments { [weak self] (querySnapshot, error) in
                    defer {
                        group.leave()
                    }
                    
                    if let error = error {
                        print("사용자 문서 조회 오류: \(error)")
                        return
                    }
                    guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                        print("사용자 문서를 찾을 수 없습니다.")
                        return
                    }
                    
                    let document = documents[0]
                    if let userName = document["name"] as? String {
                        if let userUID = document["uid"] as? String {
                            print("사용자 UID: \(userUID)")
                        } else {
                            // 사용자 UID를 찾지 못한 경우에 대한 처리
                            // print("사용자 UID를 찾을 수 없습니다.")
                        }
                        
                        if let userID = document["userid"] as? String {
                            print("사용자 ID: \(userID)")
                        } else {
                            // 사용자 ID를 찾지 못한 경우에 대한 처리
                            print("사용자 ID를 찾을 수 없습니다.")
                        }
                        
                        DispatchQueue.main.async {
                            self?.lblUser.text = "안녕하세요, \(userName) 님"
                        }
                    } else {
                        // 사용자 이름을 찾지 못한 경우에 대한 처리
                        // print("사용자 이름을 찾을 수 없습니다.")
                        DispatchQueue.main.async {
                            self?.lblUser.text = ""
                        }
                    }
                }
            }
        } else {
            // 사용자가 로그인하지 않은 경우, 빈 문자열로 레이블 텍스트를 설정합니다.
            lblUser.text = ""
        }
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
           }
       }
       
       
   }

   extension HomeViewController: FirebaseMainPageReservationListProtocol {
       func itemDownloaded(items: [FirebaseMainPageReservationListModel]) {
           mainPageDataDown = items
           DispatchQueue.main.async { [weak self] in
               self?.MainReservationCollectionView.reloadData()
           }
       }
   }

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == MainBtnCollectionView {
            print(mainPageData.count)
            return mainPageData.count
        } else if collectionView == MainReservationCollectionView {
            print(mainPageDataDown.count)
            return mainPageDataDown.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == MainBtnCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageBtnCollectionViewCell
            
            if mainPageData.isEmpty {
                // 데이터가 비어 있는 경우
                cell.imgMainPageBtn.image = nil
                cell.lblMainPageBtn.text = ""
            } else {
                let data = mainPageData[indexPath.item]
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
        } else if collectionView == MainReservationCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageReservationListCollectionViewCell
            
            if mainPageDataDown.isEmpty {
                // 데이터가 비어 있는 경우
                cell.imgMainPageReservationList.image = nil
            } else {
                let data = mainPageDataDown[indexPath.item]
                if let imageURL = URL(string: data.image) {
                    URLSession.shared.dataTask(with: imageURL) { (imageData, response, error) in
                        if let error = error {
                            print("Error downloading image: \(error)")
                        } else if let imageData = imageData, let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                cell.imgMainPageReservationList.image = image
                            }
                        }
                    }.resume()
                }
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetail" {
           let cell = sender as! UICollectionViewCell
            let indexPath = self.MainBtnCollectionView.indexPath(for: cell)
            
            FirebaseMainPageBtnMessage.name = mainPageData[indexPath!.row].name
            FirebaseMainPageBtnMessage.image2 = mainPageData[indexPath!.row].image2
            
        }
    }
}
