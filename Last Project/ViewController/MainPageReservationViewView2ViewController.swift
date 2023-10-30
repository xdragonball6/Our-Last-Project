//
//  MainPageReservationViewView2ViewController.swift
//  Last Project
//
//  Created by leeyoonjae on 10/30/23.
//

import UIKit

import Firebase

import FirebaseAuth

import FirebaseFirestore

class MainPageReservationViewView2ViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblImage2: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pickerReservationTime: UIPickerView!
    
    @IBOutlet weak var textfieldSymptom: UITextField!
    
    @IBOutlet weak var lblDnjf: UILabel!
    
    var userUID: String?
    var userID: String?
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    var selectedDate: Int?
    
    var ReservationTime = ["10시", "10시 30분", "11시", "11시 30분", "13시", "13시 30분", "14시", "14시 30분", "15시", "15시 30분", "16시", "16시 30분"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        lblDnjf.text = dateFormatter.string(from: now)
        
        textfieldSymptom.delegate = self
        
        
        pickerReservationTime.dataSource = self
        pickerReservationTime.delegate = self
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // 화면이 나타날 때마다 로그인 상태를 확인합니다.
            updateUsernameLabel()

            if let user = Auth.auth().currentUser {
                let userUID = user.uid
                print("사용자 UID: \(userUID)")
                self.userUID = userUID // userUID 값 할당
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
    

    
    @IBAction func didTappedPrevButton1(_ sender: UIButton) {
        components.month = components.month! - 1
        self.calculation()
        self.collectionView.reloadData()
        
        // 'lblDnjf' 레이블에 변경된 년도와 월을 업데이트
        lblDnjf.text = dateFormatter.string(from: cal.date(from: components)!)
    }
    
    @IBAction func didTappedNextButton1(_ sender: UIButton) {
        components.month = components.month! + 1
        self.calculation()
        self.collectionView.reloadData()
        
        // 'lblDnjf' 레이블에 변경된 년도와 월을 업데이트
        lblDnjf.text = dateFormatter.string(from: cal.date(from: components)!)
    }
    
    
    
    @IBAction func BtnMakeReservation1(_ sender: UIButton){
        // Update the user ID (You can do this asynchronously, so the following code is within a callback)
        updateUsernameLabel()
        
        let selectedImageURL = FirebaseMainPageBtnMessage.image2 // FirebaseMainPageBtnMessage에 이미지 URL을 가져오는 코드로 대체
        let selectedDate = selectedDate
        let selectedYearMonth = lblDnjf.text
        let symptom = textfieldSymptom.text
        let selectedDepartment = lblName.text


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

    
    
    
}


extension MainPageReservationViewView2ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension MainPageReservationViewView2ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 컴포넌트의 수 (보통 1)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ReservationTime.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ReservationTime[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 사용자가 피커 뷰에서 선택한 항목에 대한 동작을 추가
        _ = ReservationTime[row]
        // 여기에 선택한 시간에 대한 작업을 수행
    }
}


extension MainPageReservationViewView2ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize: CGFloat = myBoundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
}


