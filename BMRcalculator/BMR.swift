//
//  BMR.swift
//  BMRcalculator
//
//  Created by Burak Karahan on 05/04/16.
//  Copyright © 2016 Burak Karahan. All rights reserved.
//

import UIKit

class BMR: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var mheight = 0.0
    var mweight = 0.0
    var wchoice = 0
    var hchoice = 0
    var gender = 0
    var age = 10
    var active = 0
    var keysArray = [String]()
    var valuesArray = [Int]()
    
    var mDictionary = NSDictionary()
    
    @IBOutlet weak var heightLB: UILabel!
    @IBOutlet weak var heightTF: UITextField!
    
    @IBOutlet weak var ageLB: UILabel!
    @IBOutlet weak var weightLB: UILabel!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var genderLB: UILabel!
    
    @IBOutlet weak var gSwitch: UISwitch!
    @IBOutlet weak var segHeight: UISegmentedControl!
    @IBOutlet weak var segWeight: UISegmentedControl!
    
    @IBAction func heightChanged(sender: UISegmentedControl) {
        switch segHeight.selectedSegmentIndex {
        case 0:
            mheight = Double(heightTF.text!)!
            heightLB.text = "Height (cm):"
            heightTF.placeholder = "cm"
            hchoice = 0
        case 1:
            mheight = Double(heightTF.text!)! / 2.54
            heightLB.text = "Height (inch):"
            heightTF.placeholder = "inch"
            hchoice = 1
        default:
            mheight = Double(heightTF.text!)! / 30.48
            heightTF.placeholder = "feet"
            hchoice = 2
        }
    }
    @IBAction func calculate(sender: UIButton) {
        switch wchoice {
        case 0:
            mweight = Double(weightTF.text!)!
        case 1:
            mweight = Double(weightTF.text!)! / 0.4535
        case 2:
            mweight = Double(weightTF.text!)! / 6.3503
        default:
            mweight = Double(weightTF.text!)! / 6.3503
            
        }
        
        switch hchoice{
        case 0:
            mheight = Double(heightTF.text!)!
        case 1:
            mheight = Double(heightTF.text!)! / 2.54
        case 2:
            mheight = Double(heightTF.text!)! / 30.48
        default:
            mheight = Double(heightTF.text!)!
        }
        
        if gender == 0 {
            let bmr = calculateBMR()
            let bmrAlert = UIAlertController(title: "BMR Result", message: "BMR(male) = \(bmr) Calories/day", preferredStyle: UIAlertControllerStyle.Alert)
            bmrAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(bmrAlert, animated: true, completion: nil)
            
        }
        else {
            let bmr = calculateBMR()
            let bmrAlert = UIAlertController(title: "BMR Result", message: "BMR(female) = \(bmr) Calories/day", preferredStyle: UIAlertControllerStyle.Alert)
            bmrAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(bmrAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func weightChanged(sender: UISegmentedControl) {
        switch segWeight.selectedSegmentIndex {
        case 0:
            mweight = Double(weightTF.text!)!
            weightLB.text = "Weight (Kg):"
            weightTF.placeholder = "kg"
            wchoice = 0
        case 1:
            mweight = Double(weightTF.text!)! / 0.4535
            weightLB.text = "Weight (lbs):"
            weightTF.placeholder = "lbs"
            wchoice = 1
        default:
            mweight = Double(weightTF.text!)! / 6.3503
            weightLB.text = "Weight (stone):"
            weightTF.placeholder = "stone"
            wchoice = 2
        }
    }
    @IBAction func updateAge(sender: UISlider) {
        age = Int(sender.value)
        ageLB.text = "Age (\(age)year(s))"
    }
    
    @IBAction func genderChanged(sender: UISwitch) {
        if sender.on {
            gender = 0;
            genderLB.text = "Gender (male):"
        } else {
            gender = 1;
            genderLB.text = "Gender (female):"
        }
    }
    
    func calculateBMR() -> Double {
        var bmr = 0.0
        
        if gender == 0 {
            bmr = 66.0 + 13.7 * mweight + 5.0 * mheight - 6.8 * Double(age)
            switch active {
            case 1:
                bmr = bmr * 1.0
            case 2:
                bmr = bmr * 1.375
            case 3:
                bmr = bmr * 1.55
            case 4:
                bmr = bmr * 1.725
            default:
                bmr = bmr * 1.9
            }
        }
        else {
            bmr = 655.0 + 9.6 * mweight + 1.8 * mheight - 4.7 * Double(age)
            switch active {
            case 1:
                bmr = bmr * 1.0
            case 2:
                bmr = bmr * 1.375
            case 3:
                bmr = bmr * 1.55
            case 4:
                bmr = bmr * 1.725
            default:
                bmr = bmr * 1.9
            }
        }
        
        return bmr
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // The number spinning wheels (i.e., columns)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of items/rows in the componets
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return keysArray.count
    }
    
    // Called automatically multiple times. To attach the data
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keysArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        active = valuesArray[row] + 1
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = NSBundle.mainBundle()
        if let url = bundle.URLForResource("activity", withExtension: "plist") {
            mDictionary = NSDictionary(contentsOfURL: url)!
            keysArray = Array(mDictionary.allKeys as! [String])
            valuesArray = Array(mDictionary.allValues as! [Int])
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

