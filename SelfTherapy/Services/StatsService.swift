//
//  StatsService.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/11/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class StatsService {
    static let instance = StatsService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let foods : [String] = ["pizza","burger","pasta","hotdog"]
   
    var currentStep : Int? {
        get {
            return getCurrentStep()
        }
    }

     func getPeriods()-> [Periode] {
     
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode")
        request.predicate = NSPredicate(format: "user.email == %@",Auth.auth().currentUser!.email!)
        do{
            let result = try context.fetch(request)
            return result as! [Periode]
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
            return []
        }
    }
    func getCurrentStep()-> Int? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count > 0 {
                
              let user = Result.first as! UserData
                return Int(user.lastStepIndex)
            }
        } catch {
            print("error saving")
        }
          return nil
    }
    
    func setCurrentStep(stepIndex: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count > 0 {
                let user = Result.first as! UserData
               user.lastStepIndex = Int16(stepIndex)
                do {
                    try context.save()
                } catch {
                    print("error saving")
                }
            }
        } catch {
            print("error saving")
        }
    }
    func getCurrentFood()-> String {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count > 0 {
                
                let user = Result.first as! UserData
                return user.food!
            }
        } catch {
            print("error saving")
        }
        return "pizza"
    }
    func getCurrentSteps()-> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count > 0 {
                
                let user = Result.first as! UserData
                return Int(user.steps)
            }
        } catch {
            print("error saving")
        }
        return 200
    }
    
    
    func updatePeriod(depression: Int , stress: Int , anxiety: Int , mode: String) {
        if (Auth.auth().currentUser?.email == nil) {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode")
        fetchRequest.predicate = NSPredicate(format: "user.email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count == 0 {
                createFirstPeriode(depression: depression, stress: stress, anxiety: anxiety)
            }
            else {
                updateExistingPeriod(Result,depression: depression, stress: stress, anxiety: anxiety, mode: mode)
            }
        } catch {
            print("error saving")
        }
    }
    
    
    func intoNewPeriod(depression: Int , stress: Int , anxiety: Int , mode: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode")
          fetchRequest.predicate = NSPredicate(format: "user.email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count == 0 {
                createFirstPeriode(depression: depression, stress: stress, anxiety: anxiety)
            }
            else {
                newPeriod(Result,depression: depression, stress: stress, anxiety: anxiety)
            }
            
        } catch {
            print("error saving")
        }
    }
    
   fileprivate func newPeriod(_ Result: [Any] , depression: Int , stress: Int , anxiety: Int  ) {
        do {
            let periodeAvant =  Result.last as! Periode
            let user = periodeAvant.user!
            let periode = Periode(context: self.context)
            let depressionv = Dep(context: self.context)
            let anxietev = Ax(context: self.context)
            let stressv = Stress(context: self.context)
            let a2 : Double = Double((depression*10)/6)
            let str2 = String(a2)
            let a3 : Double = Double((anxiety*10)/6)
            let str3 = String(a3)
            let a4 : Double = Double((stress*10)/6)
            let str4 = String(a4)
            var rand = foods.randomElement()!
            while ( rand == user.food ){
                rand = foods.randomElement()!
            }
            user.food = rand
            debugPrint(user.food)
            debugPrint(user.steps)
            user.steps = user.steps + 100
            depressionv.dep  = str2
            anxietev.ax = str3
            stressv.stress = str4
            depressionv.date = Date()
            anxietev.date = Date()
            stressv.date = Date()
            periodeAvant.fin = Date()
            periode.id = Int16(Result.count)
            periode.debut = Date()
            periode.addToAnxietes(anxietev)
            periode.addToDepressions(depressionv)
            periode.addToStresses(stressv)
            periode.user = periodeAvant.user
        
            try context.save()
        } catch {
            print("error saving")
        }
    }
    
    
    fileprivate func updateExistingPeriod(_ Result: [Any], depression: Int , stress: Int , anxiety: Int, mode: String) {
        do {
            let periode =  Result.last as! Periode
            let depressionv = Dep(context: self.context)
            let anxietev = Ax(context: self.context)
            let stressv = Stress(context: self.context)
            let a2 : Double = Double((depression*10)/6)
            let str2 = String(a2)
            let a3 : Double = Double((anxiety*10)/6)
            let str3 = String(a3)
            let a4 : Double = Double((stress*10)/6)
            let str4 = String(a4)
            depressionv.dep  = str2
            anxietev.ax = str3
            stressv.stress = str4
            depressionv.date = Date()
            anxietev.date = Date()
            stressv.date = Date()
            switch mode {
            case "all":
                periode.addToAnxietes(anxietev)
                periode.addToDepressions(depressionv)
                periode.addToStresses(stressv)
            case "Depression":
                periode.addToDepressions(depressionv)
            case "Anxiete":
                periode.addToAnxietes(anxietev)
            case "Stress":
                periode.addToStresses(stressv)
            default :
                return
            }
            
            try context.save()
        } catch {
            print("error saving")
        }
    }
    
    fileprivate func createFirstPeriode(depression: Int , stress: Int , anxiety: Int) {
        
        do {
            let user = UserData(context: self.context)
            let periode = Periode(context: self.context)
            let depressionv = Dep(context: self.context)
            let anxietev = Ax(context: self.context)
            let stressv = Stress(context: self.context)
            let a2 : Double = Double((depression*10)/6)
            let str2 = String(a2)
            let a3 : Double = Double((anxiety*10)/6)
            let str3 = String(a3)
            let a4 : Double = Double((stress*10)/6)
            let str4 = String(a4)
            depressionv.dep  = str2
            anxietev.ax = str3
            stressv.stress = str4
            depressionv.date = Date()
            anxietev.date = Date()
            stressv.date = Date()
            periode.debut = Date()
            periode.id = 1
            periode.addToAnxietes(anxietev)
            periode.addToDepressions(depressionv)
            periode.addToStresses(stressv)
            user.email = Auth.auth().currentUser!.email!
            user.lastStepIndex = Int16(0)
            user.food = foods.randomElement()!
            user.steps = 200
            user.addToPeriods(periode)
            try context.save()
        } catch {
            print("error saving")
        }
    }
    func createEmptyFirstPeriod() {
        if (Auth.auth().currentUser?.email == nil) {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode")
        fetchRequest.predicate = NSPredicate(format: "user.email == %@",Auth.auth().currentUser!.email!)
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count == 0 {
        do {
            let user = UserData(context: self.context)
            let periode = Periode(context: self.context)
          
            periode.debut = Date()
            periode.id = 1
            user.email = Auth.auth().currentUser!.email!
            user.lastStepIndex = Int16(0)
            user.food = foods.randomElement()!
            user.steps = 200
            user.addToPeriods(periode)
            try context.save()
        } catch {
            print("error saving")
        }
    }
            
        } catch {
         print("error saving")
}
}
    
}
