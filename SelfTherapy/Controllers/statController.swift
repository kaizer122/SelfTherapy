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
    var datesAnxiete = [NSTimeIntervalSince1970]
    var datesDep = [NSTimeIntervalSince1970]
    var datesStress = [NSTimeIntervalSince1970]
    var month = ["0"]
    var nb : Int = 0
    var scores: [NSManagedObject] = []
    var scores1: [Ax] = []
    var scores2: [Dep] = []
    var scores3: [Stress] = []
    var referenceTimeInterval: TimeInterval = 0
 
    let formatter = DateFormatter()

    
    override func viewDidLoad() {
    
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM d"
        let a = seg.selectedSegmentIndex
        
   
        
        fetchScore()
        remplir()
        
        
        scores1 = fetchScore (entity: "Ax").map{ $0 as! Ax}
        scores2 = fetchScore (entity: "Dep").map{ $0 as! Dep}
        scores3 = fetchScore (entity: "Stress").map{ $0 as! Stress}
        scores1 = scores1.sorted(by: {$0.date! < $1.date!})
        scores2 = scores2.sorted(by: {$0.date! < $1.date!})
        scores3 = scores3.sorted(by: {$0.date! < $1.date!})
        ax2 = remplir(entity: "ax", scores: scores1)
        dep2 = remplir(entity: "dep", scores: scores2)
        stress2 = remplir(entity: "stress", scores: scores3)
        datesAnxiete = scores1.map{$0.date!.timeIntervalSince1970}
        datesDep = scores2.map{$0.date!.timeIntervalSince1970}
        datesStress = scores3.map{$0.date!.timeIntervalSince1970}
//        datesAnxiete.insert((scores1[0].date?.dayBefore.timeIntervalSince1970)!, at: 0)
//        datesDep.insert((scores2[0].date?.dayBefore.timeIntervalSince1970)!, at: 0)
//        datesStress.insert((scores3[0].date?.dayBefore.timeIntervalSince1970)!, at: 0)
        
        if (a == 1)
        {
            
            setChart(ax: ax2 , dates: datesAnxiete)
        }
        else  if (a == 2 )
        {
            
            setChart(ax: stress2 , dates: datesStress)
        }
        else  if (a == 3 )
        {
            
            setChart(ax: dep2 , dates:datesDep)
        }
        else if (a == 0) {
            
            // setChartData()
        }
        super.viewDidLoad()
        
    }
 
    func fetchScore(){
     
    }
    
    func remplir ()
    {
       
    }

    func setChartData() {
        
    }
    
    func setChart(ax : [Double] , dates: [TimeInterval] ) {
        
        if let minTimeInterval = dates.min() {
            referenceTimeInterval = minTimeInterval
        }
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ax.count {
            var xValue = Double(i)
           
              if (i < dates.count){
            
                 let timeInterval = dates[i]
            xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                }
           
            
            let dataEntry = ChartDataEntry(x: xValue , y:ax[i])
            yVals1.append(dataEntry)
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Anxiety")
        configDataSet(dataset: set1)
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        configLineChart(datasets: dataSets)
    }
    
    func fetchScore (entity:String) -> [NSManagedObject] {
        var temp: [NSManagedObject] = []
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appdelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        do{
           try temp = managedContext.fetch(fetchRequest)
        }catch{
            let nserror = error as NSError
            print(nserror.userInfo)
        }
        return temp
    }
    
    
    
    func remplir (entity:String ,scores: [NSManagedObject]) -> [Double]
    {
        var temp : [Double] = [0.0]
        for score in scores
        {
            let   ax = score.value(forKey: entity) as! String;
            temp.append(Double(ax)!)
        }
       return temp
        
    }
    
    
    
    
    @IBAction func change(_ sender: Any) {
        
        switch seg.selectedSegmentIndex
        {
        case 0:
            setChartData()
        case 1:
            
            setChart(ax: stress2, dates: datesStress)
        case 2:
            
            setChart(ax: ax2, dates: datesAnxiete)
        case 3:
            
            setChart(ax: dep2, dates: datesDep)
            
        default:
            break
        }
        
    }
    
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let coloTop = UIColor(red: 192/255, green: 36/255, blue: 37/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 240/255, green: 203/255, blue: 53/255, alpha: 1).cgColor
        // Colors of the gradient
        let gradientColors = [coloTop, colorBottom] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    func configDataSet(dataset: LineChartDataSet) {
        dataset.colors = [NSUIColor.red]
        dataset.mode = .cubicBezier
        dataset.cubicIntensity = 0.2
        let gradient = getGradientFilling()
        dataset.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        dataset.drawFilledEnabled = true
    }
    func configLineChart( datasets : [LineChartDataSet])  {

        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
      
        let data : LineChartData = LineChartData(dataSets: datasets)
        self.LineChart.data = data
        LineChart.xAxis.granularity = 1 //  to show intervals
        LineChart.xAxis.wordWrapEnabled = true
        LineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        LineChart.xAxis.labelPosition = .bottom // lebel position on graph
        LineChart.leftAxis.axisMaximum = 100
        LineChart.leftAxis.axisMinimum = 0
        LineChart.leftAxis.valueFormatter = ChartYAxisFormatter()
        LineChart.xAxis.centerAxisLabelsEnabled = true
        LineChart.leftAxis.drawAxisLineEnabled = true
        LineChart.xAxis.valueFormatter = xValuesNumberFormatter
        LineChart.xAxis.drawLabelsEnabled = true
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
    
    
}

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}

class ChartYAxisFormatter: NSObject {
    
}
extension ChartYAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(Int(value))+"%"
    }
    
    
}
