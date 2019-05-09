//
//  ChannelsVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/27/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class ChannelsVC: UIViewController , UITableViewDelegate, UITableViewDataSource  {
  
    
    
    @IBOutlet weak var newChannel: UITextField!
    @IBOutlet weak var tableview: UITableView!
    //vars
    var channels : [Channel] = []
    var filteredChannels = [Channel]()
    let channelsRef = Firestore.firestore().collection("channels")
    //Variables
    
    var searchBar: UISearchBar!
    
   var shouldShowSearchResults = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         listenToChannels()
         setupSearchBar()

    }
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        var frame = searchBar.frame
        frame.size.width -= 150
        searchBar.frame = frame
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView:searchBar)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredChannels.count
        }
        else {
            return channels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! channelCell
        if shouldShowSearchResults {
            cell.name!.text = filteredChannels[indexPath.row].hashtaggedName()
            cell.author!.text = "By: " + filteredChannels[indexPath.row].author
            setAvatarWithUrl(url: filteredChannels[indexPath.row].avatar,avatar: cell.avatar)
      
        } else {
        cell.name!.text = channels[indexPath.row].hashtaggedName()
        cell.author!.text = "By: " + channels[indexPath.row].author
            setAvatarWithUrl(url: channels[indexPath.row].avatar,avatar: cell.avatar)
 
        }
        return cell
    }
    func setAvatarWithUrl (url: String , avatar: UIImageView) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))
         >> RoundCornerImageProcessor(cornerRadius: 30)
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profilePlaceholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
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
                let c = Channel(name: self.newChannel.text!, author: AuthService.instance.username, avatar: Auth.auth().currentUser!.photoURL!.absoluteString)
                self.channelsRef.document(channelName).setData(c.makeRdy())
            }
        }
   
        }
  
    func listenToChannels() {	    channelsRef.addSnapshotListener { data, error in
                guard let channelsCol = data else {
                    print("Error fetching document: \(error!)")
                    return
                }
        print("entered listen")
               let channelsDocs = channelsCol.documentChanges
        for docChange in channelsDocs {
            if (Channel.getData(data: docChange.document.data()) != nil){
                switch docChange.type {
                case .added:
                    self.channels.append(Channel.getData(data: docChange.document.data())!)
                case .modified:
                    let data = docChange.document.data()
                    let channel = self.channels.indices.filter{self.channels[$0].name == (data["name"] as! String)}
                    if channel.count > 0 {
                        self.channels[channel[0]] = Channel.getData(data: docChange.document.data())!
                    }
                case .removed:
                    return
                }
            }
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

extension ChannelsVC: UISearchBarDelegate
{

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchBar.text = ""
        tableview.reloadData()
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
     shouldShowSearchResults = true
        filteredChannels = channels.filter{$0.name.contains(searchText)  ||  $0.author.contains(searchText) }
            self.tableview.reloadData() }
        else {
             shouldShowSearchResults = false
              self.tableview.reloadData()
        }
    }

    
 
}
