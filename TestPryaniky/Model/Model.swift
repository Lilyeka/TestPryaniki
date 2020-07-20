//
//  Model.swift
//  TestPryaniky
//
//  Created by Лилия Левина on 20.07.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

struct Variant:Codable {
    var id:Int
    var text:String
}

struct Data: Codable {
    var text:String?
    var url:String?
    var selectedId:Int?
    var variants:[Variant]?
}

struct NamedData: Codable {
    var name: DataType
    var data: Data
}

struct DataView: Codable {
    var data: [NamedData]
    var view:[DataType]
}

enum DataType: String, Codable {
    case hz, picture, selector
}

struct Picture {
    var url: String = ""
    var text: String = ""
    
    init(data: Data) {
        if let url = data.url, let text = data.text {
            self.url = url
            self.text = text
        }
    }
}

struct SelectorData {
    var selectedId:Int = 0
    var variants:[Variant] = [Variant]()
    
    init(data: Data) {
        if let id = data.selectedId, let variants = data.variants {
            self.selectedId = id
            self.variants = variants
        }
    }
}

struct Hz {
    var text:String = ""
    
    init(data: Data) {
        if let text = data.text {
            self.text =  text
            
        }
    }
}

