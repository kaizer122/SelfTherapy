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
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            imagePicker.delegate = self
            
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
                debugPrint(results)
                debugPrint(topResult)
                
                if topResult.identifier.contains("pizza") {
                   
                        self.bottomLabel.text = "IT IS A PIZZA!!"
                     self.view.backgroundColor = UIColor.green
                   
                        
                    }
                
                else {
                    self.bottomLabel.text = "NOT A PIZZA!!"
                    self.view.backgroundColor = UIColor.red
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
            
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
