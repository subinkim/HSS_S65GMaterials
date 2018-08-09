//
//  Configuration.swift
//  FinalProject
//
//  Created by 김수빈 on 04/08/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import Foundation

struct Configuration : Encodable, Decodable {
    private enum CodingKeys : String, CodingKey {
        case title = "title"
        case contents = "contents"
    }
    var title : String?
    var contents: [[Int]]?
}
