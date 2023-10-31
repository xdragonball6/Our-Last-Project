import Foundation
import Firebase

class FirebaseListDelete {
    let db = Firestore.firestore()

    func deleteItems(documentId: String, completion: @escaping (Bool) -> Void) {
        var status: Bool = true

        // 해당 documentId에 해당하는 문서를 삭제
        let documentReference = db.collection("reservation").document(documentId)
        
        documentReference.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                status = false
            } else {
                status = true
            }
            completion(status)
        }
    }
}
