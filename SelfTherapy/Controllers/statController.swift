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

class statController: UIViewController, ChartViewDelegate  {
    
    
    @IBOutlet weak var LineChart: LineChartView!
    
    @IBOutlet weak var RadarChart: RadarChartView!
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    
    
    var ax1 = [0.0]
    var dep1 = [0.0]
    var stress1 = [0.0]
    var ax2 = [0.0]
    var dep2 = [0.0]
    var stress2 = [0.0]
    var datesAnxiete: [Date] = []
    var datesDep: [Date] = []
    var datesStress: [Date] = []
    var startDateComponents = DateComponents()
    var startDate = Date()
    var scores: [NSManagedObject] = []
    var scores1: [Ax] = []
    var scores2: [Dep] = []
    var scores3: [Stress] = []
    let activities = ["Anxiety","Stress", "Depression",]
    
    override func viewDidLoad() {
    
        let userCalendar = Calendar.current
        startDateComponents.year = 2016
        startDate = userCalendar.date(from: startDateComponents)!
        print(startDate)
        print(startDate)
        print(startDate)
        
        let a = seg.selectedSegmentIndex
     
        fetchScore()
        remplir()
        
        scores1 = fetchScore (entity: "Ax").map{ $0 as! Ax}.sorted(by: {$0.date! < $1.date!})
        scores2 = fetchScore (entity: "Dep").map{ $0 as! Dep}.sorted(by: {$0.date! < $1.date!})
        scores3 = fetchScore (entity: "Stress").map{ $0 as! Stress}.sorted(by: {$0.date! < $1.date!})
        ax2 = remplir(entity: "ax", scores: scores1)
        dep2 = remplir(entity: "dep", scores: scores2)
        stress2 = remplir(entity: "stress", scores: scores3)
        datesAnxiete = scores1.map{$0.date!}
        datesDep = scores2.map{$0.date!}
        datesStress = scores3.map{$0.date!}
        
        if (a == 1)
        {
            
            setChart(ax: ax2 , dates: datesAnxiete , label: "Anxiety")
        }
        else  if (a == 2 )
        {
            setChart(ax: stress2 , dates: datesStress , label: "Stress")
        }
        else  if (a == 3 )
        {
            setChart(ax: dep2 , dates:datesDep, label: "Depression")
        }
        else if (a == 0) {
            configureRadarView()
        }
        super.viewDidLoad()
        
    }
 
    func fetchScore(){
     
    }
    
    func remplir ()
    {
       
    }

    func configureRadarView() {
        LineChart.isHidden =  true
        RadarChart.isHidden = false
        RadarChart.chartDescription?.enabled = false
        RadarChart.delegate = self
        RadarChart.webLineWidth = 1
        RadarChart.innerWebLineWidth = 1
        RadarChart.webColor = .lightGray
        RadarChart.innerWebColor = .lightGray
        RadarChart.webAlpha = 1
        
        let marker = RadarMarkerView.viewFromXib()!
        marker.chartView = RadarChart
        RadarChart.marker = marker
        
        let xAxis = RadarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .darkGray
        
        let yAxis = RadarChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 5
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
        let l = RadarChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.font = .systemFont(ofSize: 10, weight: .light)
        l.xEntrySpace = 7
        l.yEntrySpace = 5
        l.textColor = .white
        //        chartView.legend = l
        
        self.setRadarChartData()
        
        RadarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    func setRadarChartData() {

        let anxEntry1 = RadarChartDataEntry(value: ax2.total/Double(ax2.count-1))
        let stressEntry1 = RadarChartDataEntry(value: stress2.total/Double(stress2.count-1))
        let depEntry1 = RadarChartDataEntry(value: dep2.total/Double(dep2.count-1))
        let entries1 = [anxEntry1,stressEntry1,depEntry1]
   
        let set1 = RadarChartDataSet(values: entries1, label: "This Period")
        set1.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        set1.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 2
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        
      
        
        let data = RadarChartData(dataSets: [set1])
        data.setValueFont(.systemFont(ofSize: 8, weight: .bold))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        
        RadarChart.data = data
    }
    
    func setChart(ax : [Double] , dates: [Date] , label:String) {
      
          RadarChart.isHidden = true
        LineChart.isHidden = false
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< ax.count {

            let dataEntry = ChartDataEntry(x: Double(i) , y:ax[i])
            yVals1.append(dataEntry)
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: label)
   
        configDataSet(dataset: set1)
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        configLineChart(datasets: dataSets , dates: dates)
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
            configureRadarView()
        case 1:
            
            setChart(ax: stress2, dates: datesStress , label: "Stress")
        case 2:
            
            setChart(ax: ax2, dates: datesAnxiete, label: "Anxiety")
        case 3:
            
            setChart(ax: dep2, dates: datesDep, label: "Depression")
            
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
    func configLineChart( datasets : [LineChartDataSet] , dates: [Date])  {
      
        let data : LineChartData = LineChartData(dataSets: datasets)
        self.LineChart.data = data
        LineChart.xAxis.granularity = 1 //  to show intervals
        LineChart.xAxis.wordWrapEnabled = true
        LineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        LineChart.xAxis.labelPosition = .bottom // lebel position on graph
        LineChart.leftAxis.axisMaximum = 100
        LineChart.leftAxis.axisMinimum = 0
        LineChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12.0)
        LineChart.leftAxis.valueFormatter = ChartYAxisFormatter()
        LineChart.leftAxis.drawAxisLineEnabled = true
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
        
    
        let marker = XYMarkerView(color: UIColor(red: 106/255, green: 177/255, blue: 1, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  dates: dates )
        marker.chartView = LineChart
        marker.minimumSize = CGSize(width: 80, height: 40)
       LineChart.marker = marker
        
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

extension statController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
}
}
