//
//  DetailViewController.swift
//  SearchShoping
//
//  Created by 이민지 on 2022/05/09.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var category1: UILabel!
    @IBOutlet weak var category2: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func update(title: String, cate1: String, cate2: String, price: String, brand: String, image: URL) {
        self.titleLabel.text = title
        self.category1.text = cate1
        self.category2.text = cate2
        self.price.text = price
        self.brand.text = brand
        self.imageView.kf.setImage(with: image)
    }
}
