////
////  PredictController.swift
////  Dexter
////
////  Copyright © 2017 Clarifai. All rights reserved.
////
//
//import Clarifai_Apple_SDK
//import UIKit
//
//class PredictController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var introPredictTextView: UITextView!
//    @IBOutlet weak var modelNameLabel: UILabel!
//    @IBOutlet weak var modelSegmentedControl: UISegmentedControl!
//    @IBOutlet weak var previewImageView: UIImageView!
//    @IBOutlet weak var predictButton: UIButton!
//    @IBOutlet weak var predictionsTableView: UITableView!
//
//    var concepts: [Concept] = []
//    var customModel: Model!
//    var model: Model!
//
//    let GENERAL_MODEL_SELECTED = 0
//    let CUSTOM_MODEL_SEGMENT = 1
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if customModel == nil {
//            // Set the model to the General Model
//            // The model in the sample code below is our General Model.
//            self.model = Clarifai.sharedInstance().generalModel
//        } else {
//            // Set the model to the Custom Trained Model
//            // To learn how to train a model: TrainingController.swift
//            self.model = customModel
//            modelNameLabel.isHidden = true
//            modelSegmentedControl.isHidden = false
//            modelSegmentedControl.selectedSegmentIndex = CUSTOM_MODEL_SEGMENT
//        }
//
//        predictionsTableView.layer.borderWidth = 0.20
//        predictionsTableView.layer.borderColor = UIColor.gray.cgColor
//    }
//
//    @IBAction func predict(_ sender: Any) {
//        self.concepts.removeAll()
//
//        // Create Image(s)
//        // Initializing Image object from image Device
//        let image = Image(image: self.previewImageView.image)
//
//        // Create Data Asset(s)
//        // A Data Asset is a container for the asset in question, plus metadata
//        // related to it
//        let dataAsset = DataAsset.init(image: image)
//
//        // Create Input(s) and Input(s) Array
//        // An input object contains the data asset, temporal information, and
//        // is a fundamental component to be used by models to train on or predict.
//        let input = Input.init(dataAsset:dataAsset)
//        let inputs = [input]
//
//        /// Use the model you want to predict on. This can be a custom trained or one of our public models.
//        self.model.predict(inputs, completionHandler: {(outputs: [Output]?,error: Error?) -> Void in
//            // Iterate through outputs to learn about what has been predicted
//            for output in outputs! {
//                // Do something with your outputs
//                // In the sample code below the output concepts are being added to an array to be displayed.
//                self.concepts.append(contentsOf: output.dataAsset.concepts!)
//            }
//            self.predictionsTableView.isHidden = false
//            self.predictionsTableView.reloadData()
//        })
//    }
//
//    @IBAction func changeModel(_ sender: Any) {
//        if modelSegmentedControl.selectedSegmentIndex == GENERAL_MODEL_SELECTED {
//            model = Clarifai.sharedInstance().generalModel
//            introPredictTextView.text = "Click PREDICT to see what predictions we can get using the General Model."
//        } else {
//            model = customModel
//            introPredictTextView.text = "Click PREDICT to see what predictions we can get using your Custom Trained Model."
//        }
//    }
//
//    // MARK: internal tableview methods
//    internal func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return concepts.count
//    }
//
//    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = predictionsTableView.dequeueReusableCell(withIdentifier: "predictions") as! PredictionsCell
//
//        cell.conceptLabel.text = self.concepts[indexPath.item].name
//        cell.scoreLabel.text = String(format: "%.5f", self.concepts[indexPath.item].score)
//        
//        return cell
//    }
//}
