//
//  MainPageReservationViewViewController.swift
//  Last Project
//
//  Created by leeyoonjae on 10/26/23.
//

import UIKit

class MainPageReservationViewViewController: UIViewController {

//    @IBOutlet weak var yearMonthLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var lblDnjf: UILabel!
    
        let now = Date()
        var cal = Calendar.current
        let dateFormatter = DateFormatter()
        var components = DateComponents()
        var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        var days: [String] = []
        var daysCountInMonth = 0
        var weekdayAdding = 0
        var selectedDate: Int?

        override func viewDidLoad() {
            super.viewDidLoad()
            self.initView()
            lblDnjf.text = dateFormatter.string(from: now)
            
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
