//
//  RapportPeriod.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/24/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Charts
import CoreData
import ChameleonFramework

class RapportPeriod: UIViewController, ChartViewDelegate  {



    @IBOutlet weak var RadarChart: RadarChartView!
    var anxietyValues = [0.0]
    var depressionValues = [0.0]
    var stressValues = [0.0]
  
    var datesAnxiete: [Date] = []
    var datesDep: [Date] = []
    var datesStress: [Date] = []
    var startDate = Date()
    var scores1: [Ax] = []
    var scores2: [Dep] = []
    var scores3: [Stress] = []
    var periods: [Periode] = []
     let activities = ["Anxiety","Stress", "Depression",]
    	
    override func viewDidLoad() {
        super.viewDidLoad()
         periods = StatsService.instance.getPeriods()
       
        fetchAll ()
         configureRadarView()
        // Do any additional setup after loading the view.
    }
    @IBAction func backBTn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func fetchAll ()  {
        let currentPeriod = periods.last
        scores1 = currentPeriod?.anxietes?.allObjects as! [Ax]
        scores2 = currentPeriod?.depressions?.allObjects as! [Dep]
        scores3 = currentPeriod?.stresses?.allObjects as! [Stress]
        scores1 = scores1.sorted(by: {$0.date! < $1.date!})
        scores2 = scores2.sorted(by: {$0.date! < $1.date!})
        scores3 = scores3.sorted(by: {$0.date! < $1.date!})
        anxietyValues = scores1.map{ $0.ax }.map{ Double($0!)!}
        depressionValues = scores2.map{ $0.dep }.map{ Double($0!)!}
        stressValues = scores3.map{ $0.stress }.map{ Double($0!)!}
        anxietyValues.insert(0.0, at: 0)
        depressionValues.insert(0.0, at: 0)
        stressValues.insert(0.0, at: 0)
        datesAnxiete = scores1.map{$0.date!}
        datesDep = scores2.map{$0.date!}
        datesStress = scores3.map{$0.date!}
    }
    func configureRadarView() {
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
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        yAxis.labelCount = 5
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
        let l = RadarChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = true
        l.font = .systemFont(ofSize: 10, weight: .bold)
        l.xEntrySpace = 7
        l.yEntrySpace = 5
        l.textColor = .black
        
        
        self.setRadarChartData()
        
        RadarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    func setRadarChartData() {
        
        let data : RadarChartData
        
        let anxEntry1 = RadarChartDataEntry(value: anxietyValues.total/Double(anxietyValues.count-1))
        let stressEntry1 = RadarChartDataEntry(value: stressValues.total/Double(stressValues.count-1))
        let depEntry1 = RadarChartDataEntry(value: depressionValues.total/Double(depressionValues.count-1))
        let entries1 = [anxEntry1,stressEntry1,depEntry1]
        
        let set1 = RadarChartDataSet(values: entries1, label: "Current Period")
        set1.setColor(UIColor.flatWatermelonColorDark())
        set1.fillColor = UIColor.flatWatermelonColorDark()
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 2
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        let numberOfPeriods = periods.count
        let hasMoreThanTwoPeriods : Bool = numberOfPeriods > 1 ? true : false
        if (hasMoreThanTwoPeriods) {
            let lastPeriod = periods[numberOfPeriods-2]
            let lastPeriodAnx = lastPeriod.anxietes?.allObjects as! [Ax]
            let lastPeriodDep = lastPeriod.depressions?.allObjects as! [Dep]
            let lastPeriodStress = lastPeriod.stresses?.allObjects as! [Stress]
            let anxietyValues : [Double] = lastPeriodAnx.map{ $0.ax }.map{ Double($0!)!}
            let depValues : [Double] = lastPeriodDep.map{ $0.dep }.map{ Double($0!)!}
            let stressValues : [Double] = lastPeriodStress.map{ $0.stress }.map{ Double($0!)!}
            
            let anxEntry2 = RadarChartDataEntry(value: anxietyValues.total/Double(anxietyValues.count))
            let stressEntry2 = RadarChartDataEntry(value: stressValues.total/Double(stressValues.count))
            let depEntry2 = RadarChartDataEntry(value: depValues.total/Double(depValues.count))
            let entries2 = [anxEntry2,stressEntry2,depEntry2]
            
            let set2 = RadarChartDataSet(values: entries2, label: "Last Period")
            set2.setColor(UIColor.flatPowderBlue())
            set2.fillColor = UIColor.flatPowderBlue()
            set2.drawFilledEnabled = true
            set2.fillAlpha = 0.7
            set2.lineWidth = 2
            set2.drawHighlightCircleEnabled = true
            set2.setDrawHighlightIndicators(false)
            data = RadarChartData(dataSets: [set2,set1])
        }
        else {
            data = RadarChartData(dataSets: [set1])
        }
        
        data.setValueFont(.systemFont(ofSize: 8, weight: .bold))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        
        RadarChart.data = data
    }
 

}
class ChartXAxisFormatter2: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension RapportPeriod: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}
