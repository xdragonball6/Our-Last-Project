//
//  MyPage_Detail_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/30/23.
//

import UIKit
import Firebase
import FirebaseStorage
class MyPages_Detail_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var DogList: [FirebaseDogDBModel] = []
    
    @IBOutlet weak var cvMyDogListView: UICollectionView!
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        downloadimage(imgview: testimage)
        
        
        // 네비게이션바, 탭바 스크롤 시에도 색상 유지하는 기능
        naviAndTabSetting()
        
        setDelegateAndDataSource(cvMyDogListView)
        // 컬렉션뷰 수평 스크롤 세팅
        horizontalSetting(cvMyDogListView)
        // 컬렉션뷰 배경 투명하게
        clearBackGround(cvMyDogListView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    func readValues(){
        let addressQueryModel = FirebaseDogQueryModel()
        addressQueryModel.delegate = self
        addressQueryModel.downloadItems() // 데이터 가져와서 화면에 구성된다.
    }
    
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        SignIn.logIn_Out = false
        SignIn.userID = ""
        SignIn.username = ""
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
        let myPageImage = UIImage(systemName: "person.fill", withConfiguration: config)
        let resultAlert = UIAlertController(title: "결과", message: "로그아웃 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default, handler: { ACTION in
            if SignIn.logIn_Out == false {
                let myPageStoryboard = UIStoryboard(name: "LogIn", bundle: nil)
                let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
                let myPageImage = UIImage(systemName: "person.fill", withConfiguration: config)
                if let myPageNavController = myPageStoryboard.instantiateInitialViewController() as? UINavigationController {
                    myPageNavController.tabBarItem = UITabBarItem(title: "LogIn", image: myPageImage, tag: 0)

                    if let tabBarController = self.tabBarController {
                        if var viewControllers = tabBarController.viewControllers {
                            // Assuming "LogInViewController" is at index 3 (change the index accordingly)
                            viewControllers[3] = myPageNavController
                            tabBarController.setViewControllers(viewControllers, animated: false)
                        }
                    }
                }
            }
        })
        resultAlert.addAction(okAction)
        self.present(resultAlert, animated: true)
    }
    
    
    
    
//    func downloadimage(imgview:UIImageView){
//        storage.reference(forURL: "gs://lastproject-7fa23.appspot.com/userDog/01.jpeg").downloadURL { (url, error) in
//            let data = NSData(contentsOf: url!)
//            let image = UIImage(data: data! as Data)
//            imgview.image = image
//        }
//    }
    
    
    // 셀 개수 리턴
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvMyDogListView {
            return DogList.count
        }
        return 0
    }
    
    // 셀별 세팅
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
            cell = cvMyDogListView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! MyDog_CollectionViewCell
            let dogCell = cell as! MyDog_CollectionViewCell
            dogCell.lblName.text = DogList[indexPath.row].name
            dogCell.lblAge.text = "\(DogList[indexPath.row].age)살"
            dogCell.lblSpecies.text = DogList[indexPath.row].species
            let imagePath = DogList[indexPath.row].imageurl
            let trimmedImagePath = imagePath.trimmingCharacters(in: .whitespacesAndNewlines)
            configureCell(cell as! MyDog_CollectionViewCell, withImageURL: trimmedImagePath)
        print(DogList[indexPath.row].name)
        return cell
        }
    
    // 셀 data 담아주기. 바로 위 셀별 세팅에서 호출해서 사용한다.
    func configureCell(_ cell: UICollectionViewCell, withImageURL imageUrlString: String) {
        print(imageUrlString)
        storage.reference(forURL: "gs://lastproject-7fa23.appspot.com/userDog/\(imageUrlString).jpeg").downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            DispatchQueue.main.async {
                if let dogCell = cell as? MyDog_CollectionViewCell {
                    dogCell.imgDog.image = image
                }
            }
        }
    }
    
    
    
    // segment별 셀안의 버튼 클릭 시 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgMyDog" {
                if let button = sender as? UIButton,
                   let cell = button.superview?.superview as? MyDog_CollectionViewCell,
                   let indexPath = cvMyDogListView.indexPath(for: cell),
                   let updateView = segue.destination as? UpdateDog_UViewController {
                    updateView.receivedURL = DogList[indexPath.row].imageurl
                    updateView.receivedname = DogList[indexPath.row].name
                    updateView.receivedSpecies = DogList[indexPath.row].species
                    updateView.receivedAge = DogList[indexPath.row].age
                    updateView.receivedSeq = DogList[indexPath.row].seq
                }
            }
        }
    
    
    
    // MARK: - ViewWillAppear Setting
    func naviAndTabSetting(){
        let naviAppearance = UINavigationBarAppearance()
        naviAppearance.backgroundColor = UIColor(named: "background")
        naviAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let tabbarAppearance = UITabBarAppearance()
        tabbarAppearance.backgroundColor = UIColor(named: "background")
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = naviAppearance
        self.navigationController?.navigationBar.standardAppearance = naviAppearance
        self.navigationController?.navigationBar.compactAppearance = naviAppearance

        self.tabBarController?.tabBar.scrollEdgeAppearance = tabbarAppearance
        self.tabBarController?.tabBar.standardAppearance = tabbarAppearance
    }
    
    func setDelegateAndDataSource(_ view: UICollectionView){
        view.delegate = self
        view.dataSource = self
    }
    
    func horizontalSetting(_ view: UICollectionView){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
    }
    
    func clearBackGround(_ view: UICollectionView){
        view.backgroundColor = UIColor.clear
        view.backgroundView = nil
    }
    

}// MyPages_Detail_ViewController

extension MyPages_Detail_ViewController: FirebaseDogQueryModelProtocol{
    func itemDownloaded(items: [FirebaseDogDBModel]) {
        DogList = items
        self.cvMyDogListView.reloadData() // Table을 재실행시킨다. 화면구성 새로 해주는 작업
    }
    
}
// 컬렉션뷰 사이즈와 간격 세팅
extension MyPages_Detail_ViewController: UICollectionViewDelegateFlowLayout{
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 1픽셀
    }
    
    // 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Cell Size ( 옆 라인을 고려하여 설정)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvMyDogListView {
            return CGSize(width: 380+10, height: 120)
        }else {
            return CGSize(width: 380+10, height: 120) // 마진 10 주기
        }
        
    }
    
}
