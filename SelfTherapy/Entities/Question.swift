//
//  question.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/14/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation
class Question {
    private(set) public var num: String
    private(set) public var text: String
       private(set) public var categorie: String
    public var reponses: [String]
    
    init( num: String , text : String , categorie: String , reponses : [String]) {
        self.num = num
        self.text = text
        self.categorie = categorie
        self.reponses = reponses
    }
    
}
