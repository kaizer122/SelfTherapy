//
//  StatsService.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/11/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import CoreData

class StatsService {
    static let instance = StatsService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   

     func getPeriods()-> [Periode] {
        let request : NSFetchRequest<Periode> = Periode.fetchRequest()
        do{
            let result = try context.fetch(request)
            return result
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
            return []
        }
    }
    
    func updatePeriod(depression: Int , stress: Int , anxiety: Int , mode: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode")
        do{
            let Result = try context.fetch(fetchRequest)
            if Result.count == 0 {
                createFirstPeriode(depression: depression, stress: stress, anxiety: anxiety)
            }
            else {
                upadePeriode(Result,depression: depression, stress: stress, anxiety: anxiety, mode: mode)
            }
        } catch {
            print("error saving")
        }
    }
    
    
    func intoNewPeriod(depression: Int , stress: Int , anxiety: Int , mode: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Periode") // cast it as NSManagedObject instead of NSFetchRequestResult if we want to access the object values
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
    
    func newPeriod(_ Result: [Any] , depression: Int , stress: Int , anxiety: Int ) {
        do {
            let periodeAvant =  Result.last as! Periode
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
            periodeAvant.fin = Date()
            periode.id = Int16(Result.count)
            periode.debut = Date()
            periode.addToAnxietes(anxietev)
            periode.addToDepressions(depressionv)
            periode.addToStresses(stressv)
            
            try context.save()
        } catch {
            print("error saving")
        }
    }
    
    
    fileprivate func upadePeriode(_ Result: [Any], depression: Int , stress: Int , anxiety: Int, mode: String) {
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
            try context.save()
        } catch {
            print("error saving")
        }
    }
}
