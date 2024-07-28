//
//  ProfileQuestionsDataModel.swift
//  SafeYou
//
//  Created by armen sahakian on 20.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

//import Foundation
//
//@objc class ProfileQuestionsDataModel: NSObject, Decodable {
//    
//    var id: Int
//    var title: String
//    var title2: String
//    var type: String
//    var options: [ProfileQuestionsOption]
//    
//    public init(id: Int, title: String, title2: String, type: String, options: [ProfileQuestionsOption]) {
//        self.id = id
//        self.title = title
//        self.title2 = title2
//        self.type = type
//        self.options = options
//        
//        super.init()
//    }
//    
//    @objc public func create(dict: Array<Any>) -> [ProfileQuestionsDataModel] {
//        let decoder = JSONDecoder()
//        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
//        let dataArray = try! decoder.decode([ProfileQuestionsDataModel].self, from: data!)
//        return dataArray
//    }
//    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case title2
//        case type
//        case options
//    }
//    
//    // For Objective-C support and Swift Decodable
//    public required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let id = try container.decode(Int.self, forKey: .id)
//        let title = try container.decode(String.self, forKey: .title)
//        let title2 = try container.decode(String.self, forKey: .title2)
//        let type = try container.decode(String.self, forKey: .type)
//        let options = try container.decode([ProfileQuestionsOption].self, forKey: .options)
//        
//        self.init(id: id, title: title, title2: title2, type: type, options: options)
//    }
//}
//
//struct ProfileQuestionsOption {
//    let id: Int?
//    let name: String?
//    let provinceId: Int?
//    let type: String?
//}
//
//extension ProfileQuestionsOption: Codable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case provinceId = "province_id"
//        case type
//    }
//}
