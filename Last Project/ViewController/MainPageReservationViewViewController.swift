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

        override func viewDidLoad() {
            super.viewDidLoad()
            self.initView()
            lblDnjf.text = dateFormatter.string(from: now)
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

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MainPageReservationCollectionViewCell

            switch indexPath.section {
            case 0:
                cell.lblCalendar.text = weeks[indexPath.row]
            default:
                cell.lblCalendar.text = days[indexPath.row]
            }

            if indexPath.row % 7 == 0 {
                cell.lblCalendar.textColor = .red
            } else if indexPath.row % 7 == 6 {
                cell.lblCalendar.textColor = .blue
            } else {
                cell.lblCalendar.textColor = .black
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
