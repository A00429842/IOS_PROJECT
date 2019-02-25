//
//  FiltersViewController.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-02-04.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import Foundation

class FiltersViewController: UIViewController {
    
    var delegate: FiltersViewControllerDelegate?
    // MARK: - IBOutlets

    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var isOpenNow: UISwitch!
    @IBOutlet weak var rankByLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rankBySelectedLabel: UILabel!

    @IBOutlet weak var toolBar: UIToolbar!
    // MARK: - Properties

    var rankByDictionary: [String] = ["prominence", "distance"]
    
    var selected: String {
        return UserDefaults.standard.string(forKey: "selected") ?? ""
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.isHidden = true
        toolBar.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        rankByLabel.isUserInteractionEnabled = true
        
        if let row = rankByDictionary.index(of:selected) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rankByLabelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rankByLabel.addGestureRecognizer(tapGestureRecognizer)
        rankBySelectedLabel.text = rankByDictionary.first
        let radiusValue = UserDefaults.standard.object(forKey: "radiusValue")
        radiusSlider.value = radiusValue as? Float ?? Float(Constants.defaultRadius)
        
        let rankbyText = UserDefaults.standard.object(forKey: "rankbyText")
        rankBySelectedLabel.text = rankbyText as? String ?? Constants.defaultRankby
    
        let opennow = UserDefaults.standard.object(forKey: "opennow")
        isOpenNow.isOn = opennow as? Bool ?? Constants.defaultOpennow
        

        pickerView.isUserInteractionEnabled = true
        
    }
    

    @IBAction func resetClick(_ sender: UIButton) {
        radiusSlider.value = Float(Constants.defaultRadius)
        rankBySelectedLabel.text = Constants.defaultRankby
        isOpenNow.isOn = Constants.defaultOpennow
        UserDefaults.standard.removeObject(forKey: "radiusValue")
        UserDefaults.standard.removeObject(forKey: "rankbyText")
        UserDefaults.standard.removeObject(forKey: "opennow")

    }
    
    @IBAction func saveClick(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(radiusSlider.value,forKey: "radiusValue")
        UserDefaults.standard.set(rankBySelectedLabel.text, forKey:
        "rankbyText")
        UserDefaults.standard.set(rankBySelectedLabel.text, forKey: "selected")
        UserDefaults.standard.set(isOpenNow.isOn, forKey:"opennow")
        
    }
    // MARK: - IBActions

    @objc func rankByLabelTapped() {
        print("label was tapped")
        pickerView.isHidden = !pickerView.isHidden
        toolBar.isHidden = !toolBar.isHidden
    }

    
    @IBAction func doneClick(_ sender: UIBarButtonItem) {
        print("done was tapped")
        pickerView.isHidden = true
        toolBar.isHidden = true
    }
    

    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func radiusSliderChangedValue(_ sender: UISlider) {
        print("slider value changed to \(sender.value) int \(Int(sender.value))")

    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print("switch value was changed to \(sender.isOn)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.filterResponse(raduis: radiusSlider.value, rankby: rankBySelectedLabel.text ?? Constants.defaultRankby, opennow: isOpenNow.isOn)
    }
}

extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rankByDictionary.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rankByDictionary[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankBySelectedLabel.text = rankByDictionary[row]
    }
    
}


