//
//  SecondViewController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/12/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    let txts = ["All subjects","Depression","Anxiety","Stress"]
    let imgs = ["1","2","3","4"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "quizzCell") as! QuizzCell
        cell.img.image = UIImage(named: imgs[indexPath.row])
        cell.txt.text  = txts[indexPath.row]
        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

