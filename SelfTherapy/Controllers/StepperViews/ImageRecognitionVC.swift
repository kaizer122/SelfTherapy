//
//  ImageRecognitionVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/24/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ImageRecognitionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

        @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    var classificationResults : [VNClassificationObservation] = []
        
        let imagePicker = UIImagePickerController()
        var foodName = ""
    var didLoadImg = false
        override func viewDidLoad() {
            super.viewDidLoad()
            
            imagePicker.delegate = self
      imageView.alpha = 0.4
          
            foodName = StatsService.instance.getCurrentFood()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        if !didLoadImg {
        switch (foodName) {
        case "pizza":
            imageView.image = #imageLiteral(resourceName: "pizzabg")
        case "burger":
            imageView.image = UIImage(named: "burgerbg")
        case "pasta":
            foodName = "spaghetti"
            imageView.image = UIImage(named: "pastabg")
        case "hotdog":
            imageView.image = UIImage(named: "hotdogbg")
        default :
            imageView.image = #imageLiteral(resourceName: "pizzabg")
        }
            didLoadImg = true
        bottomLabel.text = "Take a picture of "+foodName.capitalized+" !"
            }
         }
    

        func detect(image: CIImage) {
            
            // Load the ML model through its generated class
            guard let model = try? VNCoreMLModel(for: Food101().model) else {
                fatalError("can't load ML model")
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first
                    else {
                        fatalError("unexpected result type from VNCoreMLRequest")
                        }
                      let secondResult = results[1]
                print(results.first!.identifier)
                if (topResult.identifier.contains(self.foodName) || secondResult.identifier.contains(self.foodName))  {
                   NotificationCenter.default.post(name: .didCompleteStep, object: nil)
                        self.bottomLabel.text = "IT IS REALLY " + self.foodName.uppercased() + "!!"
                      self.bottomLabel.textColor = UIColor.green
                    }
                else {
                    self.bottomLabel.text = "Not sure this is " + self.foodName + "!"
                    self.bottomLabel.textColor = UIColor.red
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            do { try handler.perform([request]) }
            catch { print(error) }
        }
        
        
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if let image = info[.originalImage] as? UIImage {
                
                imageView.image = image
                
                imagePicker.dismiss(animated: true, completion: nil)
                
                
                guard let ciImage = CIImage(image: image) else {
                    fatalError("couldn't convert uiimage to CIImage")
                }
                
                detect(image: ciImage)
                
            }
        }
        
        
        @IBAction func cameraTapped(_ sender: Any) {
            DispatchQueue.main.async {
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
         
            self.imagePicker.modalPresentationStyle = .overCurrentContext
            self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
    @IBAction func galleryTapped(_ sender: Any) {
         DispatchQueue.main.async {
        self.imagePicker.sourceType = .photoLibrary

        self.imagePicker.allowsEditing = false
          self.imagePicker.modalPresentationStyle = .overCurrentContext
       self.present(self.imagePicker, animated: true, completion: nil)
    }
}
    
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }




}


