import Foundation
import Firebase
import FirebaseAuth

protocol FirebaseMainPageReservationListListProtocol {
    func itemDownloaded(items: [FirebaseMainPageReservationListListModel])
}

class FirebaseMainPageReservationListList {
    var delegate: FirebaseMainPageReservationListListProtocol?
    
    var userID: String?
    
    let db = Firestore.firestore()
    
    func setUserID(_ userID: String) {
        self.userID = userID
        print("사용자 ID 설정 완료: \(userID)")
    }
    
    func MainPageUser() {
        var locations: [FirebaseMainPageReservationListListModel] = []
        
        if let userID = self.userID {
            db.collection("reservation").whereField("userid", isEqualTo: userID).getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("문서를 가져오는 중 오류 발생: \(err)")
                } else {
                    print("데이터 다운로드 완료 1")
                    
                    for document in querySnapshot!.documents {
                        let documentID = document.documentID // Firebase 문서의 고유 ID
                        
                        guard
                            let userid = document.data()["userid"] as? String,
                            let day = document.data()["day"] as? Int,
                            let department = document.data()["department"] as? String,
                            let image = document.data()["image"] as? String,
                            let symptom = document.data()["symptom"] as? String,
                            let year = document.data()["year"] as? String
                        else {
                            print("One or more fields are nil or couldn't be cast to String.")
                            continue // 유효하지 않은 데이터는 건너뜁니다.
                        }
                        
                        let query = FirebaseMainPageReservationListListModel(documentID: documentID, day: day, department: department, image: image, symptom: symptom, userid: userid, year: year)
                        locations.append(query)
                    }
                    
                    self.delegate?.itemDownloaded(items: locations)
                }
            })
        }
    }
}
