//
//  DetailsViewController.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-02-08.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    var place : PlaceDetails!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeIndicator.isHidden = true
        placeLabel.text = place.name
    }
    
    func showActivityIndicator() {
        activeIndicator.isHidden = false
        activeIndicator.startAnimating()
        detailButton.isEnabled = false
    }
    
    func hideActivityIndicator() {
        activeIndicator.stopAnimating()
        activeIndicator.isHidden = true
        detailButton.isEnabled = true
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        
        if let placeId = place.placeId{
            showActivityIndicator()
            GooglePlacesAPI.requestPlaceDetail(placeId) { (status, json) in
                print(json ?? "")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    guard let jsonObj = json else { return }
                    if let result = jsonObj["result"] as?
                        [String: Any]{
                        let websiteText = result["website"] as? String
                        let phoneText = result["formatted_phone_number"] as? String
                        self.changeLabelText(website:websiteText ?? "", phone:phoneText ?? "")
                    }
                }

            }
        }else {
            self.changeLabelText(website: "", phone: "")
            print("placeId is not existed")
        }
        
        
    }
    
    func changeLabelText(website:String, phone:String)
    {
        websiteLabel.text = website
        phoneLabel.text = phone
    }
    
}


