//
//  MyPage_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/19/23.
//

import UIKit
import Firebase
import FirebaseStorage
class MyPageViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfSpecies: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var lblWarning: UILabel!
    
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadimage(imgview: imgView)
    }
    
    func downloadimage(imgview:UIImageView){
            storage.reference(forURL: "gs://lastproject-7fa23.appspot.com/userDog/main.jpeg").downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                imgview.image = image
            }
        }
    
    @IBAction func bringImages_Btn(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    
    @IBAction func btnInsert(_ sender: UIButton) {
        let name = tfName.text ?? ""
        let species = tfSpecies.text ?? ""
        let age = tfAge.text ?? ""
        let updateModel = FirebaseDogInsertVM()
        let result = updateModel.insertItems(name: name, age: age, userid: SignIn.userID, imageurl: "\(Int(Date().timeIntervalSince1970))", species: species)
            let resultAlert = UIAlertController(title: "결과", message: "입력 되었습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {
                ACTION in self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        
        if let selectedImage = imgView.image{
            uploadImageToFirebaseStorage(image: selectedImage) { downloadURL in
                if let imageURL = downloadURL {
                    // 이미지 업로드가 완료되면 imageURL을 사용하여 원하는 곳에 저장하거나 표시합니다.
                    print("Image uploaded to Firebase Storage. Download URL: \(imageURL)")
                }
            }
        }
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (URL?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // 현재 타임스탬프를 사용하여 파일 이름 생성
        let imageFileName = "\(Int(Date().timeIntervalSince1970)).jpeg"

        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // 이미지를 Firebase Storage에 업로드
            let imageRef = storageRef.child("userDog/\(imageFileName)")
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error uploading image to Firebase Storage: \(error!.localizedDescription)")
                    completion(nil)
                } else {
                    // 이미지 업로드가 성공하면 다운로드 URL을 가져옴
                    imageRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            completion(downloadURL)
                        } else {
                            print("Error getting download URL: \(error?.localizedDescription ?? "unknown error")")
                            completion(nil)
                        }
                    }
                }
            }
        } else {
            completion(nil)
        }
    }

    
    
    
    
    // keyboard 세팅
    func setKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y = -50 //키보드가 나타나면서 어디까지 나타날지 y의 값을 나타내는 녀석
    }
    
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0 // y좌표를 0으로 돌려 원래 화면 나오게 하기
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
            }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// MyPage_ViewController
extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
        imgView.image = image
        lblWarning.text = ""
    }
        
    print("\(info)")

    picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    }
}



