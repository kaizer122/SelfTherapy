//
//  XYMarkerView.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/9/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//
import Foundation
import Charts

public class XYMarkerView: BalloonMarker {
   
    fileprivate var dates:[Date]

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                dates: [Date] ) {
        self.dates = dates

        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let formatter = DateFormatter()
         var string = ""
        formatter.dateFormat = "'on:' MMM dd 'at' HH:mm"
        if (Int(entry.x) == 0) {
           setLabel("")
        }
        else if (Int(entry.x) <= dates.count){
            string = String(Int(entry.y))+"%  "+formatter.string(from: dates[Int(entry.x-1)]) }
        else {
            string = String(entry.y)+"%  "
        }
        setLabel(string)
    }
    
}
