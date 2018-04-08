//
//  RegisterViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/14/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
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

    @IBAction func regersterPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) {
            (user, error) in
            
            if error != nil {
                print("--------------------")
                print("--------------------")
                print(error?.localizedDescription ?? "haha")
                SVProgressHUD.dismiss()
                
//                if let errCode = AuthErrorCode(rawValue: error!._code) {
//
//                    switch errCode {
//                    case .invalidEmail:
//                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Please type valid Email", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatRed()])
//                        print(1)
//                    case .emailAlreadyInUse:
//                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Email already exits", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatRed()])
//                        print(2)
//                    case .wrongPassword:
//                        self.passwordText.attributedPlaceholder = NSAttributedString(string: "The password must be 6 characters long or more", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatRed()])
//                        print(3)
//                    default:
//                        print("Create User Error: \(error!)")
//                    }
//                }
                self.showTopLevelAlert(titel: "Error", message: (error?.localizedDescription)!)
                
            }else{
                
                SVProgressHUD.dismiss()
                print("Success")
                
                self.performSegue(withIdentifier: "gototodaytask", sender: self)
            }
        }
        
    }
    
    func showTopLevelAlert(titel: String, message: String) {
        let alertController = UIAlertController (title: titel, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(firstAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}
