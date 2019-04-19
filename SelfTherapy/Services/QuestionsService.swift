//
//  QuestionsService.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/14/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class QuestionsService {
    
    static let instance = QuestionsService()
    let defaults = UserDefaults.standard

    static var questions = [Question]()
    
    
    fileprivate func fetch(_ json: JSON , mode:String) {
        for i in 0..<json.count {
            
            let jsonReponses = json[i]["reponses"].array
           
            var reps = [String]()
            for j in 0..<jsonReponses!.count {
                reps.append(jsonReponses![j]["text"].stringValue )
            }
            if (mode  == "all") {
            
            QuestionsService.questions.append(Question(num: json[i]["num"].stringValue,
                                                       text: json[i]["text"].stringValue,
                                                       categorie: json[i]["categorie"].stringValue,
                                                       reponses: reps))
            } else {
                if (mode == json[i]["categorie"].stringValue) {
                    QuestionsService.questions.append(Question(num: json[i]["num"].stringValue,
                                                               text: json[i]["text"].stringValue,
                                                               categorie: json[i]["categorie"].stringValue,
                                                               reponses: reps))
                }
            }
            
        }
    }
    
    func getQuestions (mode:String ,completion: @escaping CompletionHandler) {
        QuestionsService.questions.removeAll()
            Alamofire.request(URL_QUESTIONS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
                
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    do {
                        let json = try JSON(data: data)
                     
                        self.fetch(json, mode: mode)
                        
                       }
                     catch {
                        completion(false)
                        print(error)
                    }
                 
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            }
    }
    
}
