//
//  MainPageReservationViewViewController.swift
//  Last Project
//
//  Created by leeyoonjae on 10/26/23.
//

import UIKit

import Firebase

import FirebaseAuth

import FirebaseFirestore

class MainPageReservationViewViewController: UIViewController, UITextFieldDelegate {

//    @IBOutlet weak var yearMonthLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblDnjf: UILabel!
    
    @IBOutlet weak var pickerReservationTime: UIPickerView!
    
    @IBOutlet weak var textfieldSymptom: UITextField!
    
    @IBOutlet weak var pickerImageName: UIPickerView!
    
    // 1. 건강검진    2. 피부과   3. 예방접종     4. 중성화
    var userUID: String?
    
    
        var ReservationImageName = ["https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/neuteringSurgery%2FGroup%2024.png?alt=media&token=9458c583-883f-4b06-8717-4607b56bdbc5&_gl=1*1su67xh*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5ODYwNjA4NS4xMDkuMS4xNjk4NjA2Mjc2LjE2LjAuMA..", "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/neuteringSurgery%2FGroup%2026.png?alt=media&token=e917d8e0-69c1-47b1-b29d-bbec86d2ebe5&_gl=1*skf9o5*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5ODYwNjA4NS4xMDkuMS4xNjk4NjA2MzU5LjU3LjAuMA..", "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/neuteringSurgery%2FGroup%2025.png?alt=media&token=390d88ee-96ee-45df-a05e-069c6652cdad&_gl=1*m6ngo8*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5ODYwNjA4NS4xMDkuMS4xNjk4NjA2MzE3LjM4LjAuMA..", "https://firebasestorage.googleapis.com/v0/b/lastproject-7fa23.appspot.com/o/neuteringSurgery%2F%E1%84%8C%E1%85%AE%E1%86%BC%E1%84%89%E1%85%A5%E1%86%BC%E1%84%92%E1%85%AA.png?alt=media&token=b9a25875-82e3-4cc6-9480-5a02dcd87bb7&_gl=1*19e6818*_ga*MTMxNjcyMzI2LjE2OTE0MjQ4MTU.*_ga_CW55HF8NVT*MTY5ODYwNjA4NS4xMDkuMS4xNjk4NjA2MTk1LjM1LjAuMA.."]
    
        
        var ReservationImageDetail = ["건강검진","피부과","예방접종","중성화 수술"]
    
        var ReservationTime = ["10시", "10시 30분", "11시", "11시 30분", "13시", "13시 30분", "14시", "14시 30분", "15시", "15시 30분", "16시", "16시 30분"]
    
        let now = Date()
        var cal = Calendar.current
        let dateFormatter = DateFormatter()
        var components = DateComponents()
        var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        var days: [String] = []
        var daysCountInMonth = 0
        var weekdayAdding = 0
        var selectedDate: Int?

        var userID: String?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initView()
            lblDnjf.text = dateFormatter.string(from: now)
         
            textfieldSymptom.delegate = self
            
            
            pickerReservationTime.dataSource = self
            pickerReservationTime.delegate = self
            
            pickerImageName.dataSource = self
            pickerImageName.delegate = self
            
//            for i in 0..<ReservationTime.count{
//                let time = Text(named: ReservationTime[i])
//            }
//            
            
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 로그인 상태를 확인합니다.
        updateUsernameLabel()

        
        
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
                    if let userUID = document["uid"] as? String {
                        print("사용자 UID: \(userUID)")
                        self?.userUID = userUID
                    } else {
                        // print("사용자 UID를 찾을 수 없습니다.")
                    }
                    
                    if let userID = document["userid"] as? String {
                        print("사용자 ID: \(userID)")
                        self?.userID = userID // 사용자 ID를 설정
                    } else {
                        print("사용자 ID를 찾을 수 없습니다.")
                    }
                }
            }
        }
    }

 


    
    
    
    

        private func initView() {
            self.initCollection()

            dateFormatter.dateFormat = "yyyy년 M월"
            components.year = cal.component(.year, from: now)
            components.month = cal.component(.month, from: now)
            components.day = 1
            self.calculation()
        }

        private func initCollection() {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
        }

        private func calculation() {
            let firstDayOfMonth = cal.date(from: components)
            let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
            daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
            weekdayAdding = 2 - firstWeekday

            self.days.removeAll()
            for day in weekdayAdding...daysCountInMonth {
                if day < 1 {
                    self.days.append("")
                } else {
                    self.days.append(String(day))
                }
            }
        }

    
    @IBAction func didTappedPrevButton(_ sender: UIButton) {
        components.month = components.month! - 1
        self.calculation()
        self.collectionView.reloadData()
        
        // 'lblDnjf' 레이블에 변경된 년도와 월을 업데이트
        lblDnjf.text = dateFormatter.string(from: cal.date(from: components)!)
    }
    
    
    @IBAction func didTappedNextButton(_ sender: UIButton) {
        components.month = components.month! + 1
        self.calculation()
        self.collectionView.reloadData()
        
        // 'lblDnjf' 레이블에 변경된 년도와 월을 업데이트
        lblDnjf.text = dateFormatter.string(from: cal.date(from: components)!)
    }
    
    

    @IBAction func BtnMakeReservation(_ sender: UIButton){
        // Update the user ID (You can do this asynchronously, so the following code is within a callback)
        updateUsernameLabel()
        
        let userID = self.userID
        let selectedImageURL = ReservationImageName[pickerImageName.selectedRow(inComponent: 0)]
        let selectedDate = selectedDate
        let selectedYearMonth = lblDnjf.text
        let symptom = textfieldSymptom.text
        let selectedDepartment = ReservationImageDetail[pickerImageName.selectedRow(inComponent: 0)]

        // 이제 각 값은 옵셔널이 아니며, 옵셔널 바인딩 없이 직접 사용할 수 있습니다.

        // Prepare data to be saved to Firestore
        let reservationData: [String: Any] = [
            "userid": userID as Any,
            "image": selectedImageURL as Any,
            "day": selectedDate as Any,
            "year": selectedYearMonth as Any,
            "symptom": symptom as Any,
            "department": selectedDepartment as Any
        ]
        
        let db = Firestore.firestore()
        let reservationsRef = db.collection("reservation")  // "reservation"은 컬렉션 이름입니다.

        let alertController = UIAlertController(title: "예약 확인", message: "예약을 생성하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "예", style: .default) { (action) in
            // Firestore에 예약 추가
            reservationsRef.addDocument(data: reservationData) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully!")
                    // 여기에서 다른 예약이 생성된 후에 수행할 작업을 추가할 수 있습니다.
                }
            }
        }

        
        let noAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    
    
    
    
    
    
    
//    {
//        // updateUsernameLabel() 메서드를 호출하여 사용자 ID를 가져옵니다.
//        updateUsernameLabel()
//        
//        // 사용자 ID 출력
//        if let userID = self.userID {
//            print("사용자 ID 1234: \(userID)")
//            
//            // 이제 이 사용자 ID를 사용하여 Firebase에 저장하거나 다른 작업을 수행할 수 있습니다.
//        } else {
//            print("사용자 ID를 찾을 수 없습니다.")
//        }
//    }








    
    
    }

    extension MainPageReservationViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch section {
            case 0:
                return 7
            default:
                return self.days.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.section == 1 { // 날짜 셀을 선택하는 경우에만 처리
                let selectedDay = indexPath.row - weekdayAdding + 1
                if selectedDay >= 1 && selectedDay <= daysCountInMonth {
                    if selectedDate == selectedDay {
                        selectedDate = nil
                    } else {
                        selectedDate = selectedDay
                    }
                    collectionView.reloadData()
                }
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageReservationCollectionViewCell

            switch indexPath.section {
            case 0:
                cell.lblCalendar.text = weeks[indexPath.row]
            default:
                cell.lblCalendar.text = days[indexPath.row]
            }

            if indexPath.row % 7 == 0 {
                cell.lblCalendar.textColor = .red // 일요일
            } else if indexPath.row % 7 == 6 {
                cell.lblCalendar.textColor = .blue // 토요일
            } else {
                cell.lblCalendar.textColor = .black // 나머지 요일
            }

            if selectedDate != nil {
                if indexPath.section == 1 {
                    let selectedDay = indexPath.row - weekdayAdding + 1
                    if selectedDay == selectedDate {
                        cell.lblCalendar.textColor = .gray // 선택한 날짜는 회색으로 표시
                    }
                }
            }

            return cell
        }


    }

    extension MainPageReservationViewViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
            let cellSize: CGFloat = myBoundSize / 9
            return CGSize(width: cellSize, height: cellSize)
        }
    }

extension MainPageReservationViewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // pickerReservationTime 데이터 소스 및 델리게이트 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerReservationTime {
            return ReservationTime.count
        } else if pickerView == pickerImageName {
            return ReservationImageName.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerReservationTime {
            return ReservationTime[row]
        } else if pickerView == pickerImageName {
            return nil  // pickerImageName에서는 텍스트가 아니라 이미지를 표시
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerReservationTime {
            _ = ReservationTime[row]
            
        } else if pickerView == pickerImageName {
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == pickerImageName {
            // 텍스트와 이미지를 함께 표시할 뷰 생성
            let combinedView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.size.width, height: 50))
            
            // 이미지를 표시할 UIImageView 생성 및 이미지 로드
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // 이미지 크기 설정
            imageView.contentMode = .scaleAspectFit
            
            if let url = URL(string: ReservationImageName[row]) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }.resume()
            }
            
            // 텍스트를 표시할 UILabel 생성
            let label = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.size.width - 60, height: 50))
            label.text = ReservationImageDetail[row]
            label.font = UIFont.systemFont(ofSize: 25.0) // 글씨 크기 설정
            label.textAlignment = .center // 가운데 정렬
            
            // 이미지와 텍스트를 함께 표시할 뷰에 추가
            combinedView.addSubview(imageView)
            combinedView.addSubview(label)
            
            return combinedView
        } else if pickerView == pickerReservationTime {
            // 텍스트를 표시할 UILabel 생성
            let label = UILabel()
            label.text = ReservationTime[row]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 25.0)
            return label
        }
        
        return UIView() // 다른 경우에는 빈 뷰 반환
    }
}
