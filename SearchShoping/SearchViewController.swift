//
//  SearchViewController.swift
//  SearchShoping
//
//  Created by 이민지 on 2022/05/09.
//

import UIKit
import Kingfisher
import Alamofire

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var uiCollectionView: UICollectionView!
    
    var items: [Search] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("itemCount \(items.count)")
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        let item = items[indexPath.item]
        let url = URL(string: item.image)!
        cell.update(title: item.title, imageUrl: url)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController

        DispatchQueue.main.async {
            let title = item.title
            let cate1 = item.category1
            let cate2 = item.category2
            let price = item.lprice
            let brand = item.brand
            let url = URL(string: item.image)!
            vc.update(title: title, cate1: cate1, cate2: cate2, price: price, brand: brand, image: url)
        }
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 5
        let itemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 2
        let height = width * 10 / 7
        return CGSize(width: width, height: height)
    }
}

class SearchCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func update(title: String, imageUrl: URL) {
        self.title.text = title
        self.imageView.kf.setImage(with: imageUrl)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismissKeyboard()
        
        guard let searchbarItem = searchBar.text, searchbarItem.isEmpty == false else { return }
        
        SearchAPI.search(searchbarItem) { [weak self] itemList in
            guard let self = self else { return }
            DispatchQueue.main.async {
                print(itemList)
                self.items = itemList
                self.uiCollectionView.reloadData()
            }
        }
    }
}

class SearchAPI {
    static func search(_ items: String, completion: @escaping ([Search]) -> ()) {
//        let session = URLSession(configuration: .default)
        let clientID = "V2kFdPDbE1jCHcRNs7Bi"
        let clientKEY = "EMDufaZVi7"
//
//
        let query = "https://openapi.naver.com/v1/search/shop.json"
        let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        let queryURL = URL(string: encodingQuery)!
//
//        var requestURL = URLRequest(url: queryURL)
//        requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
//        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let param = ["query" : items]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "X-Naver-Client-Id" : clientID,
            "X-Naver-Client-Secret" : clientKEY
        ]
        
        AF.request(encodingQuery, method: .get, parameters: param, headers: headers)
            .responseData { response in
                print(response)
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(SearchField.self, from: data)
                        let items = result.items
                        completion(items)
                    } catch {
                        completion([])
                    }
                case .failure(_):
                    completion([])
                }
            }
        
    }
}
        
//        let dataTask = session.dataTask(with: requestURL) { data, response, error in
//            let successRange = 200..<300
//            guard error == nil, let statuCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statuCode) else { return completion([])}
//
//            guard let resultData = data else {
//                completion([])
//                return
//            }
//
//            let items = SearchAPI.parseItems(resultData)
//            completion(items)
//            return
//        }
//        dataTask.resume()
//    }
    
//    static func parseItems(_ data: Data) -> [Search] {
//        let decoder = JSONDecoder()
//
//        do {
//            let response = try decoder.decode(SearchField.self, from: data)
//            let items = response.items
//            print("data--> \(items)")
//            return items
//        } catch let error {
//            print("error \(error.localizedDescription)")
//            return []
//        }
//    }
