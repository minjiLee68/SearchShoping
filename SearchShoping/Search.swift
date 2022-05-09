//
//  Search.swift
//  SearchShoping
//
//  Created by 이민지 on 2022/05/09.
//

import UIKit

struct SearchField: Codable {
    let items: [Search]
    
//    enum CodingKeys: String, CodingKey {
//        case items = "items"
//    }
}

struct Search: Codable {
    let title: String
    let image: String
    let lprice: String
    let brand: String
    let category1: String
    let category2: String
    let link: String
}
