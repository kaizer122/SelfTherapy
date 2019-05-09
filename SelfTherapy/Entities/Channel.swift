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
    private(set) public var avatar: String
   
    init(name : String , author:String , avatar:String) {
        self.name = name
        self.author = author
        self.avatar = avatar
    }
    
    func hashtaggedName() -> String {
        return "#"+self.name
    }
    
    func makeRdy()-> [String : Any]{
        return [ "name" : self.name ,
                 "author" : self.author,
            "avatar" : self.avatar
        
        ]
     
    }
    static func getData(data: [String : Any]) -> Channel?{
        if (data["avatar"] != nil) {
            return Channel(name: data["name"] as! String, author: data["author"] as! String	,avatar: data["avatar"] as! String)}
        else { return nil}
    }
    
}
