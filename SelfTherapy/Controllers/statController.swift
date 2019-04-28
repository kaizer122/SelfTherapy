//
//  statController.swift
//  SelfTherapy
//
//  Created by mahdi on 4/23/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Charts
import CoreData

class statController: UIViewController {
    
    
    @IBOutlet weak var LineChart: LineChartView!
    	
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    
    
    var ax1 = [0.0]
    var dep1 = [0.0]
    var stress1 = [0.0]
    
    var ax2 = [0.0]
    var dep2 = [0.0]
    var stress2 = [0.0]
    
    var month = ["0"]
    
    
    var nb : Int = 0
    

    override func viewDidLoad() {
        let a = seg.selectedSegmentIndex
        
       if (a == 1)
       {
        
        setChart(ax: ax2)
        }
        else  if (a == 2 )
       {
        
        setChart(ax: stress2)
        }
       else  if (a == 3 )
       {
        
        setChart(ax: dep2)
        }
       else if (a == 0) {
        
        setChartData()
        }
        
        fetchScore()
        remplir()
        
        
        fetchScore1()
        remplir1()
        
        fetchScore2()
        remplir2()
        
        fetchScore3()
        remplir3()
        setChartData()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    var scores: [NSManagedObject] = []
    var scores1: [NSManagedObject] = []
    var scores2: [NSManagedObject] = []
    
    var scores3: [NSManagedObject] = []
    
    func fetchScore(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appdelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "All")
        do{
            try scores = managedContext.fetch(fetchRequest)
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
        }
    }

    func remplir ()
    {
        for score in scores
        {
let   ax = score.value(forKey: "ax") as! String;
            let   stress = score.value(forKey: "stress") as! String;
            let   dep = score.value(forKey: "dep") as! String;
            
           

            let a1 : Double?  = Double(ax)
            let b1 :Double?  = Double(stress)
            let c1 : Double? = Double(dep)

            ax1.append(a1!)
            stress1.append(b1!)
            dep1.append(c1!)
            
            
            
        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setChartData() {
    
    var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
    for i in 0 ..< scores.count + 1 {
    yVals1.append(ChartDataEntry(x:Double(i) , y:ax1[i]))
    }
        
    let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Anxiety")
    set1.axisDependency = .left // Line will correlate with left axis values
    set1.setColor(UIColor.red.withAlphaComponent(0.5))
    set1.setCircleColor(UIColor.red)
    set1.circleRadius = 3.0
    set1.fillAlpha = 65 / 255.0
    set1.fillColor = UIColor.red
    set1.highlightColor = UIColor.white
    set1.drawCircleHoleEnabled = false
    
    var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
    for i in 0 ..< scores.count + 1 {
    yVals2.append(ChartDataEntry(x:Double(i) , y: dep1[i]))
    }
    
    let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Depression")
    set2.axisDependency = .left // Line will correlate with left axis values
    set2.setColor(UIColor.green.withAlphaComponent(0.5))
    set2.setCircleColor(UIColor.green)
    set2.circleRadius = 3.0
    set2.fillAlpha = 65 / 255.0
    set2.fillColor = UIColor.green
    set2.highlightColor = UIColor.white
    set2.drawCircleHoleEnabled = false
    set2.circleHoleRadius = 0.5
    
    var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
    for i in 0 ..< scores.count  + 1{
    yVals3.append(ChartDataEntry(x:Double(i) , y: stress1[i]))
    }
    
    let set3: LineChartDataSet = LineChartDataSet(values: yVals3, label: "Stress")
    set3.axisDependency = .left // Line will correlate with left axis values
    set3.setColor(UIColor.blue.withAlphaComponent(0.5))
    set3.setCircleColor(UIColor.blue)
    set3.circleRadius = 3.0
    set3.fillAlpha = 65 / 255.0
    set3.fillColor = UIColor.blue
    set3.highlightColor = UIColor.white
    set3.drawCircleHoleEnabled = false
    
    //3 - create an array to store our LineChartDataSets
    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
    dataSets.append(set1)
    dataSets.append(set2)
    dataSets.append(set3)
    
    //4 - pass our months in for our x-axis label value along with our dataSets
    let data : LineChartData = LineChartData(dataSets: dataSets)
    
    // data.setValueTextColor(UIColor.white)
    
    //5 - finally set our data
    self.LineChart.data = data
    
    LineChart.xAxis.granularity = 1 //  to show intervals
    LineChart.xAxis.wordWrapEnabled = true
    
    LineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 8.0)
    
    LineChart.xAxis.labelPosition = .bottom // lebel position on graph
    
    LineChart.legend.form = .line // indexing shape
    LineChart.xAxis.drawGridLinesEnabled = false // show gird on graph
    LineChart.rightAxis.drawLabelsEnabled = false// to show right side value on graph
    LineChart.data?.setDrawValues(false) //
    LineChart.chartDescription?.text = ""
    LineChart.doubleTapToZoomEnabled = false
    LineChart.pinchZoomEnabled = false
    LineChart.scaleXEnabled = false
    LineChart.scaleYEnabled = false
    
    LineChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    
    
    func setChart(ax : [Double]) {
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ax.count {
            yVals1.append(ChartDataEntry(x:Double(i) , y:ax[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Anxiety")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.circleRadius = 3.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = false
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
     
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data : LineChartData = LineChartData(dataSets: dataSets)
        
        // data.setValueTextColor(UIColor.white)
        
        //5 - finally set our data
        self.LineChart.data = data
        
        LineChart.xAxis.granularity = 1 //  to show intervals
        LineChart.xAxis.wordWrapEnabled = true
        
        LineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 8.0)
        
        LineChart.xAxis.labelPosition = .bottom // lebel position on graph
        
        LineChart.legend.form = .line // indexing shape
        LineChart.xAxis.drawGridLinesEnabled = false // show gird on graph
        LineChart.rightAxis.drawLabelsEnabled = false// to show right side value on graph
        LineChart.data?.setDrawValues(false) //
        LineChart.chartDescription?.text = ""
        LineChart.doubleTapToZoomEnabled = false
        LineChart.pinchZoomEnabled = false
        LineChart.scaleXEnabled = false
        LineChart.scaleYEnabled = false
        
        LineChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    
    func fetchScore1(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appdelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ax")
        do{
            try scores1 = managedContext.fetch(fetchRequest)
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
        }
    }
    
    func fetchScore2(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appdelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dep")
        do{
            try scores2 = managedContext.fetch(fetchRequest)
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
        }
    }
    
    func fetchScore3(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appdelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stress")
        do{
            try scores3 = managedContext.fetch(fetchRequest)
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
        }
    }
    
    
    func remplir1 ()
    {
        for score in scores1
        {
            let   ax = score.value(forKey: "ax") as! String;
            
            
            
            let a1 : Double?  = Double(ax)
            
            
            ax2.append(a1!)
            
            
            
        }
        
        
        
    }
    
    
    func remplir2 ()
    {
        for score in scores2
        {
   
            let   dep = score.value(forKey: "dep") as! String;
            
            
            
            let c1 : Double? = Double(dep)
            
          
            dep2.append(c1!)
            
            
            
        }
        
        
        
    }
    
    
    func remplir3 ()
    {
        for score in scores3
        {
            let   stress = score.value(forKey: "stress") as! String;
            
            
            
            let b1 :Double?  = Double(stress)
            
            stress2.append(b1!)
            
            
            
        }
        
        
        
    }
    
    

    
    @IBAction func change(_ sender: Any) {
        
        switch seg.selectedSegmentIndex
        {
        case 0:
            setChartData()
        case 1:
            
            setChart(ax: stress2)
        case 2:
            
            setChart(ax: ax2)
        case 3:
            
            setChart(ax: dep2)
            
        default:
            break
        }
        
    }
    
    
    
    

}
