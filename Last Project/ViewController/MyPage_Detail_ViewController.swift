//
//  MyPage_Detail_ViewController.swift
//  Last Project
//
//  Created by 박지환 on 10/25/23.
//

import UIKit

class MyPage_Detail_ViewController: UIViewController, UICollectionViewDataSource {
    
    

    @IBOutlet weak var cvMyPet_ListView: UICollectionView!
    var dogList: [dogModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션바, 탭바 스크롤 시에도 색상 유지하는 기능
        naviAndTabSetting()
        
        setDelegateAndDataSource(cvMyPet_ListView)
        // 컬렉션뷰 수평 스크롤 세팅
        horizontalSetting(cvMyPet_ListView)
        // 컬렉션뷰 배경 투명하게
        clearBackGround(cvMyPet_ListView)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        dogList = []
        // 무비데이터 들고오기
        readValues()
    }
    
    func readValues() {
        let dogQueryModel = DogQueryModel()
        dogQueryModel.delegate = self
        dogQueryModel.fetchDataFromAPI(userid: SignIn.username)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 셀별 세팅
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        cell = cvMyPet_ListView.dequeueReusableCell(withReuseIdentifier: "rankCell", for: indexPath) as! MyDog_CollectionViewCell
        let movieCell = cell as! MyDog_CollectionViewCell
        movieCell.lblName.text = "\(indexPath.row + 1)"
        let imagePath = dogList[indexPath.row].dog_image
        let trimmedImagePath = imagePath.trimmingCharacters(in: .whitespacesAndNewlines)
        configureCell(cell as! MyDog_CollectionViewCell, withImageURL: trimmedImagePath)
        
        return cell
    }
    
    // 셀 data 담아주기. 바로 위 셀별 세팅에서 호출해서 사용한다.
    func configureCell(_ cell: UICollectionViewCell, withImageURL imageUrlString: String) {
        let imageUrl = URL(string: imageUrlString)
        
        URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // 비동기방식으로 이미지 불러와 담아주기
                DispatchQueue.main.async {
                    if let dogCell = cell as? MyDog_CollectionViewCell {
                        dogCell.imgDog.image = image
                    }
                }
            }
        }.resume()
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
    
    
    
    
    

}

// 컬렉션뷰 사이즈와 간격 세팅
extension MyPage_Detail_ViewController: UICollectionViewDelegateFlowLayout{
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
        if collectionView == cvMyPet_ListView {
            return CGSize(width: 154+10, height: 185)
        }else {
            return CGSize(width: 127+10, height: 185) // 마진 10 주기
        }
        
    }
    
}
extension MyPage_Detail_ViewController: DogProtocol {
    func itemDownloaded(item: [dogModel]) {
        dogList = item
        self.cvMyPet_ListView.reloadData()
    }
}
