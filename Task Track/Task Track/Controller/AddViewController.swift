//
//  AddViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/14/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit

class AddViewController: UIViewController  {
    
    
    
    
    @IBOutlet weak var inputTaskField: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func datePickerPressed(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        let a = formatter.string(from: datePicker.date)
        
        print(a)
    }
    

}
