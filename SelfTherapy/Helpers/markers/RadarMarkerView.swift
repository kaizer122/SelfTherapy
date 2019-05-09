//
//  RadarMarkerView.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/9/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import Foundation
import Charts

public class RadarMarkerView: MarkerView {
    @IBOutlet var label: UILabel!
    
    public override func awakeFromNib() {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String.init(format: "%d %%", Int(round(entry.y)))
        layoutIfNeeded()
    }
}
