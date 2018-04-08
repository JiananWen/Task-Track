//
//  LoginViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/14/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import ChameleonFramework

class LoginViewController: UIViewController {
    
    
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
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) {
            (user, error) in
            
            if error != nil{
                print(error!)
                print("-------------")
                
                SVProgressHUD.dismiss()
                
//                self.emailText.attributedPlaceholder = NSAttributedString(string: "Please type valid email", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatRed()])
//
//                self.passwordText.attributedPlaceholder = NSAttributedString(string: "The password must be 6 characters long or more", attributes: [NSAttributedStringKey.foregroundColor : UIColor.flatRed()])
                self.showTopLevelAlert(titel: "Error", message: (error?.localizedDescription)!)
                
            }else{
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "logtotask", sender: self)
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
