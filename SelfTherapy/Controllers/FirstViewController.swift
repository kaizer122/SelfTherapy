//
//  FirstViewController.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/12/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import TransitionButton
import Kingfisher

class FirstViewController: CustomTransitionViewController  {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var lpStartedAt: UILabel!
    @IBOutlet weak var lpEndedAt: UILabel!
    @IBOutlet weak var cpStartedAt: UILabel!
    @IBOutlet weak var lpInfo: UIStackView!
    @IBOutlet weak var nextTask: UILabel!
    var periods : [Periode] = []
    let dateformatter : DateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
    }
    override func viewWillAppear(_ animated: Bool) {
        periods = StatsService.instance.getPeriods()
        setupUserInfo()
        super.viewWillAppear(animated)
    }
    func setupUserInfo () {
        if AuthService.instance.isLoggedIn {
            username.text = Auth.auth().currentUser!.displayName!
            setAvatarWithUrl(url: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", avatar: profileImg)
            if ( periods.count > 1) {
                lpInfo.isHidden = false
                lpStartedAt.text = dateformatter.string(from: periods[periods.count-2].debut!)
                 lpEndedAt.text = dateformatter.string(from: periods[periods.count-2].fin!)
            } else {
                lpInfo.isHidden = true
            }
            if (periods.count > 0) {
                cpStartedAt.text = dateformatter.string(from: periods[periods.count-1].debut!)
            }
            switch periods[periods.count-1].user?.lastStepIndex {
            case 0 :
                nextTask.text = "Take an image of your favourite pizza !"
            case 1 :
                 nextTask.text = "Choose any of our therapeutic music and listen to it !"
            case 2 :
                 nextTask.text = "Take a walk of 2000 Steps!"
            case 3 :
                  nextTask.text = "You have finished all your tasks ! Now Take your next quizz."
            default :
              nextTask.text = "Take an image of your favourite pizza !"
            }
            
            
        }
        else {
            debugPrint(AuthService.instance.userEmail)
        }
    }
    func setAvatarWithUrl (url: String , avatar: UIImageView) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 165, height: 165))
            >> RoundCornerImageProcessor(cornerRadius: 82.5)
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
    @IBAction func logoutClicked(_ sender: Any) {
        AuthService.instance.logoutUser()
   
    }
}

