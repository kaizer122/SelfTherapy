//
//  Channel.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/27/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation

struct Channel : Codable {
      private(set) public var name: String
      private(set) public var author: String
    init(name : String , author:String) {
        self.name = name
        self.author = author
    }
    func hashtaggedName() -> String {
        return "#"+self.name
    }
    func makeRdy()-> [String : Any]{
        return [ "name" : self.name ,
                 "author" : self.author
        ]
     
    }
    static func getData(data: [String : Any]) -> Channel{
        return Channel(name: data["name"] as! String, author: data["author"] as! String)
    }
    
}
