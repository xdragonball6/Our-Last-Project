import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainPageListListTableTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var listTableView: UITableView!

    var userID: String?
    var userUID: String?


        var data: [FirebaseMainPageReservationListListModel] = []


    override func viewDidLoad() {
        
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
        
            super.viewDidLoad()
            // userID 속성을 설정
            if let user = Auth.auth().currentUser, let userEmail = user.email {
                let db = Firestore.firestore()
                let userRef = db.collection("users").whereField("userid", isEqualTo: userEmail)
                userRef.getDocuments { [weak self] (querySnapshot, error) in
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
                    }
                    if let userID = document["userid"] as? String {
                        print("사용자 ID: \(userID)")
                        self?.userID = userID
                        // readVales 함수를 이제 호출합니다.
                        self?.readVales()
                    } else {
                        print("사용자 ID를 찾을 수 없습니다.")
                    }
                }
            }
        }
    
    func readVales(){
        let queryModel = FirebaseMainPageReservationListList()
        queryModel.delegate = self
        queryModel.setUserID(userID!) // 사용자 ID를 설정
        queryModel.MainPageUser()
        // print("유저 \(String(describing: userID))")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MainPageListListTableViewCell

        let item = data[indexPath.row]

        // 데이터를 셀의 레이블과 이미지 뷰에 설정
        cell.lblDepartment.text = item.department
        cell.lblDay.text = String(item.day) 
        cell.lblYear.text = item.year

        if let imageURL = URL(string: item.image) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgImage.image = image
                    }
                }
            }.resume()
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = data[indexPath.row]
            let documentId = item.documentID // Firebase 문서의 고유 ID

            // Firebase에서 항목 삭제
            let deleteModel = FirebaseListDelete()
            deleteModel.deleteItems(documentId: documentId) { success in
                if success {
                    // Firebase에서 삭제 성공한 경우에만 로컬 데이터도 삭제
                    self.data.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } else if editingStyle == .insert {
            // 삽입하는 경우의 로직
        }
    }

    // 한글로 삭제 버튼 텍스트 설정
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "예약 취소"
    }



    }





extension MainPageListListTableTableViewController: FirebaseMainPageReservationListListProtocol{
    func itemDownloaded(items: [FirebaseMainPageReservationListListModel]) {
        data = items
        self.listTableView.reloadData()
    }
}
