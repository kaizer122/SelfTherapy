//
//  QuizzController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/13/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Lottie
import UICircularProgressRing
import CoreData

class QuizzController: UIViewController {

    // outlets
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var progress: UICircularProgressRing!
    @IBOutlet var quesTxt: UILabel!
    @IBOutlet var QuestionMarkAnim: LOTAnimationView!
    // animation constraints
    @IBOutlet weak var ans1Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var ans2Constraint: NSLayoutConstraint!
    @IBOutlet weak var ans3Constraint: NSLayoutConstraint!
    @IBOutlet weak var ans4Constraint: NSLayoutConstraint!
    // variables
    var current = 0
    var anxiety = 0
    var stress = 0
    var depression = 0
    var currentQuestion : Question?
    var mode:String = "all"
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        loadQuestions(mode: mode)
        
    }
    func setupButtons() {
        answer1.titleLabel?.adjustsFontSizeToFitWidth = true
        answer1.titleLabel?.lineBreakMode = .byWordWrapping
        answer1.titleLabel?.numberOfLines = 2
        answer2.titleLabel?.adjustsFontSizeToFitWidth = true
        answer2.titleLabel?.lineBreakMode = .byClipping
        answer2.titleLabel?.numberOfLines = 2
        answer3.titleLabel?.adjustsFontSizeToFitWidth = true
        answer3.titleLabel?.lineBreakMode = .byClipping
        answer3.titleLabel?.numberOfLines = 2
        answer4.titleLabel?.adjustsFontSizeToFitWidth = true
        answer4.titleLabel?.lineBreakMode = .byClipping
        answer4.titleLabel?.numberOfLines = 2
        
        ans1Constraint.constant -= self.view.bounds.width
        ans2Constraint.constant -= self.view.bounds.width
        ans3Constraint.constant -= self.view.bounds.width
        ans4Constraint.constant -= self.view.bounds.width
        quesTxt.alpha = 0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation(name: "QuestionMark", anim: QuestionMarkAnim)
    }
    
    
    func startAnimation(name:String , anim:LOTAnimationView) {
        anim.setAnimation(named: name)
        anim.animationSpeed = 1
        anim.play()
    }
    
    @IBAction func optClicked(_ sender: UIButton) {
        switch currentQuestion!.categorie {
        case "Depression":
            self.depression += sender.tag * 2
        case "stress":
            self.stress += sender.tag * 2
        case "anxiete":
            self.anxiety += sender.tag * 2
        default:
            print ("errreur categorie ")
            return
        }
        debugPrint(depression)
        print(anxiety)
        print (stress)
        print(mode)
        animateQuestionOut(at: current)
        
    }
    
    func loadQuestions(mode: String) {
        QuestionsService.instance.getQuestions(mode: mode){ (success) in
            if success {
                self.current = 0
                self.currentQuestion = QuestionsService.questions[0]
                self.goToQuestion(at: 0)
                debugPrint(QuestionsService.questions.count)
                
            }
            else {
                debugPrint("somethin is wrong")
                
            }
        }
    }
    func goToQuestion (at i: Int) {
        quesTxt.text =  QuestionsService.questions[i].text
        answer1.setTitle(QuestionsService.questions[i].reponses[0], for: .normal)
        answer2.setTitle(QuestionsService.questions[i].reponses[1], for: .normal)
        answer3.setTitle(QuestionsService.questions[i].reponses[2], for: .normal)
        answer4.setTitle(QuestionsService.questions[i].reponses[3], for: .normal)
        self.animateQuestionIn(at: i)
    }
    
    func animateQuestionIn (at i: Int) {
        
        startAnimation(name: "QuestionMark", anim: QuestionMarkAnim)
        UIView.animate(withDuration: 1, delay:0 , options: .curveEaseOut, animations: {
            self.quesTxt.alpha = 1
        } )
        UIView.animate(withDuration: 0.5, delay:0.3 , options: .curveEaseOut, animations: {
            self.ans1Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        } )
        UIView.animate(withDuration: 0.5, delay:0.6 , options: .curveEaseOut, animations: {
            self.ans2Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        } )
        UIView.animate(withDuration: 0.5, delay:0.9 , options: .curveEaseOut, animations: {
            self.ans3Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        } )
        UIView.animate(withDuration: 0.5, delay:1.2 , options: .curveEaseOut, animations: {
            self.ans4Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        } )
    }
    fileprivate func saveData() {
        switch mode {
        case "all":
            updateCoreData(entityName: "Dep", firstArg: "dep", value : depression)
            updateCoreData(entityName: "Ax", firstArg: "ax" , value: anxiety)
            updateCoreData(entityName: "Stress", firstArg: "stress", value: stress)
        case "Depression":
            updateCoreData(entityName: "Dep", firstArg: "dep", value: depression)
        case "anxiete":
            updateCoreData(entityName: "Ax", firstArg: "ax", value: anxiety)
        case "stress":
            updateCoreData(entityName: "Stress", firstArg: "stress", value: stress)
       default:
        return
        }
    }
    func updateCoreData(entityName: String , firstArg: String , value: Int) {
     
        // 2
        let entity = NSEntityDescription.entity(forEntityName: entityName,in: managedContext)!
        
        let person = NSManagedObject(entity: entity,insertInto: managedContext)
        let a2 : Double = Double((value*10)/6)
        // 3
        let str2 = String(a2)
        person.setValue(str2, forKeyPath: firstArg)
        person.setValue(Date(), forKeyPath: "date")
        
        // 4
        do {
            try managedContext.save()
            
            print("save for dep")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func animateQuestionOut (at i: Int) {
        if (current < QuestionsService.questions.count-1 ) {
            current += 1
            currentQuestion = QuestionsService.questions[current]
            let percentage:Double = 100.0/Double(QuestionsService.questions.count)
            let currentfloat:Double = Double(Double(current)*percentage)
            print (percentage)
            progress.startProgress(to: CGFloat(currentfloat), duration: 2)
            
            QuestionMarkAnim.animationSpeed = -1
            QuestionMarkAnim.play()
            
            
            UIView.animate(withDuration: 1, delay:0 , options: .curveEaseOut, animations: {
                self.quesTxt.alpha = 0
            } )
            UIView.animate(withDuration: 0.5, delay:0.3 , options: .curveEaseOut, animations: {
                self.ans1Constraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: 0.5, delay:0.6 , options: .curveEaseOut, animations: {
                self.ans2Constraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: 0.5, delay:0.9 , options: .curveEaseOut, animations: {
                self.ans3Constraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            } )
            UIView.animate(withDuration: 0.5, delay:1.2 , options: .curveEaseOut, animations: {
                self.ans4Constraint.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.goToQuestion(at: i+1)
            })
            
        } else {
            
            
            
            saveData()
            
            
            performSegue(withIdentifier: "rapport", sender: nil)

            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rapport" {
           
           
            let viewController:RapportController = segue.destination as! RapportController
            
            viewController.stress = stress
            viewController.depression = depression
            viewController.anxiety = anxiety
            viewController.mode = mode
            
        }
        
    }
    
 
    @IBAction func skipClicked(_ sender: Any) {
        
        saveData()
        
        performSegue(withIdentifier: "rapport", sender: nil)

    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

