//
//  musique.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/13/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import AVFoundation
var audioPlayer = AVAudioPlayer()


class MusicVC: UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate{
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var slid: UISlider!
    
    var time = 0.1
    
    var songs:[String] = ["Mighty Fire" , "Find My Way Home" , "In Case You Forgot" , "Otis McMusic" , "Fingers" , "Scarlet Fire" , "Relaxing"]
    var images:[String] = ["11","22","33","44","55","66","66"]
    var thisSong = 0
    var audioStuffed = false
    var once = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getsongname()
        let audioPath = Bundle.main.path(forResource: "Relaxing", ofType: ".mp3")
        nom.text = "Relaxing"
        image.image = UIImage(named:"66")
        try! audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
    }
    override func viewDidAppear(_ animated: Bool) {
        audioPlayer.play()
        audioStuffed = true
        slid.maximumValue = Float(audioPlayer.duration)
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
    }
    
    func getsongname()
    {
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songpath = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songpath
            {
                var mySong = song.absoluteString
                
                if (mySong.contains(".mp3"))
                {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                    
                    
                }
            }
        }
        catch {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cel1", for: indexPath) as! c2
        cell.ima.image = UIImage(named:images [indexPath.row]   )
        cell.lab.text = songs[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row > 0 && indexPath.row < images.count){
        do
        {
            image.image =  UIImage(named:images [indexPath.row]   )
           // nom.text = songs [indexPath.row]
            
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            thisSong = indexPath.row
            nom.text = songs [indexPath.row]
            image.image = UIImage(named: images[indexPath.row])
            audioStuffed = true
            slid.maximumValue = Float(audioPlayer.duration)
            updatetime()
        }
        catch
        {
            print ("ERROR")
        }
        }
    }
    
    
    @IBAction func change(_ sender: UISlider) {
        if audioStuffed == true
        {
            audioPlayer.volume = sender.value
     
        }
    }
    
    func playThis(thisOne:String)
    {
        do
        {
            let audioPath = Bundle.main.path(forResource: thisOne, ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
        }
        catch
        {
            print ("ERROR")
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        if audioStuffed == true && audioPlayer.isPlaying
        {
            audioPlayer.pause()
        }
    }
    
    @IBAction func playy(_ sender: Any) {
        
        if audioStuffed == true && audioPlayer.isPlaying == false
        {
            audioPlayer.play()
        }    }
    
    @IBAction func ch(_ sender: Any) {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
   @objc func updatetime ()
    {
        let currentTime  = Float(audioPlayer.currentTime)
        slid.value = currentTime
        
        if (currentTime >= slid.maximumValue-10 && !once) {
            once = true
            print("notification sent")
            NotificationCenter.default.post(name: .didCompleteStep, object: nil)
        }
    }
    
}

