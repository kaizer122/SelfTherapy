//
//  ContainerViewController.swift
//  StepViewExample
//
//  Created by Vlados iOS on 12/17/18.
//  Copyright © 2018 VladislavShilov. All rights reserved.
//

import UIKit
import StepView

final class ContainerViewController: UIViewController {
    @IBOutlet private weak var stepView: StepView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    private var count = 1
    private var pageViewController: UIPageViewController!
    var currentStep : Int = 0
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: String.init(describing: ImageRecognitionVC.self)),
            self.getViewController(withIdentifier: String.init(describing: MusicVC.self)),
            self.getViewController(withIdentifier: String.init(describing: StepsCounterVC.self)),
             self.getViewController(withIdentifier: String.init(describing: EndVC.self))
            
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupControllers()
    }
    
    // MARK: - Setup views
    
    private func setupControllers() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = containerView.bounds
        containerView.addSubview(pageViewController.view)
        currentStep = StatsService.instance.currentStep ?? 0
       let firstController = pages[currentStep]
        stepView.selectedStep = currentStep+1
       pageViewController.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
    
    }
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    private func getControllerToShow(from index: Int) -> UIViewController? {
        if index - 1 < pages.count {
            if (index == pages.count){
                nextButton.setTitle("Go to Quizz!", for: .normal)
                nextButton.backgroundColor = .orange
            }
            return pages[index - 1]
        }
        else {
     
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EndToQuizz") {
                let quizzVC :QuizzController = segue.destination as! QuizzController
            quizzVC.showButton = true
            quizzVC.newPeriodStarted = true
        }
    }
    // MARK: - Actions
    
    @IBAction func nextButtonDidPress(_ sender: Any) {
        stepView.showNextStep()
        
        if let controllerToShow = getControllerToShow(from: stepView.selectedStep) {
            if count > 1 {
                 count = 1
                performSegue(withIdentifier: "EndToQuizz", sender: nil)
                return
            }
            if (controllerToShow.restorationIdentifier == "EndVC") {
                count = count+1
            }
            StatsService.instance.setCurrentStep(stepIndex: (StatsService.instance.currentStep ?? 0 )+1)
                pageViewController.setViewControllers([controllerToShow], direction: .forward, animated: true, completion: nil)
            
//        }
        }
    }
 
}
