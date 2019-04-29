//
//  ChannelsVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/27/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Firebase


class ChannelsVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newChannel: UITextField!
    @IBOutlet weak var tableview: UITableView!
    //vars
    var channels : [Channel] = []
    let channelsRef = Firestore.firestore().collection("channels")
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         listenToChannels()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath)
        cell.textLabel!.text = channels[indexPath.row].hashtaggedName()
        cell.detailTextLabel!.text = "By: " + channels[indexPath.row].author
        return cell
    }

    @IBAction func addChannelClicked(_ sender: Any) {
        guard let channelName = newChannel.text ,  newChannel.text != "" else {
            makeAlert(message: "Please enter a channel name first!")
            return }
        let docRef = channelsRef.document(channelName)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
             self.makeAlert(message: "This channel name is taken, please choose another name.")
            } else {
                let c = Channel(name: self.newChannel.text!, author: AuthService.instance.username)
                self.channelsRef.document(channelName).setData(c.makeRdy())
            }
        }
   
        }
  
    func listenToChannels() {
    channelsRef.addSnapshotListener { data, error in
                guard let channelsCol = data else {
                    print("Error fetching document: \(error!)")
                    return
                }
        print("entered listen")
               let channelsDocs = channelsCol.documentChanges
        for docChange in channelsDocs {
           self.channels.append(Channel.getData(data: docChange.document.data()))
        }
       self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "channelToChat", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "channelToChat" {
            let indexPath = sender as! IndexPath
            let chatvc :ChatVC = segue.destination as! ChatVC
            chatvc.user = Auth.auth().currentUser!
            chatvc.channel = channels[indexPath.row]
        }
    }
 
    
    func makeAlert( message: String ) {
        let alert = UIAlertController(title: "Sorry !", message: message, preferredStyle: .alert)
        let backButton = UIAlertAction (title: "Okay", style: .cancel, handler: nil)
        alert.addAction(backButton)
        self.present(alert,animated: true, completion: nil)
    }

}
