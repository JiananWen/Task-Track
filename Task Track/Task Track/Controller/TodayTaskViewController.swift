//
//  TodayTaskViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/14/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Firebase
import SVProgressHUD

class TodayTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICircularProgressRingDelegate {
    
    
    //show not finished task
    var taskArr : [Task] = [Task]()
    
    //note all today's task
    var taskArrFull : [Task] = [Task]()
    
    

    @IBOutlet var taskTableView: UITableView!
    @IBOutlet weak var circle: UICircularProgressRingView!
    @IBOutlet var inputHeight: NSLayoutConstraint!
    @IBOutlet weak var taskInputTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        
        taskInputTextField.delegate = self
        circle.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target : self, action: #selector(tableViewTapped))
        
        taskTableView.addGestureRecognizer(tapGesture)
        
        
        taskTableView.register(UINib(nibName: "MessageCell", bundle : nil), forCellReuseIdentifier: "customMessageCell")
        
        loadtodaydata()
        
        configureTableView()
        
        //set circle progress
        circleChanged()
        
        taskTableView.separatorStyle = .none
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for : indexPath) as! CustomMessageCell
        
        cell.messageBody.text = taskArr[indexPath.row].taskText
            
        let imagename = "Counter-" + String(indexPath.row + 1)
        cell.avatarImageView.image = UIImage(named: imagename)
    
        return cell
    }
    
    
    //delete task from arr, but not errase from database
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let finishedtask = taskArr[indexPath.row]
            
            taskArr.remove(at: indexPath.row)
            
            for t in taskArrFull{
                if(t.id == finishedtask.id){
                    t.finished = true
                    //motify database t finished value to true
                    
                    let todayDateString = getTodayDate()
                    let userid = Auth.auth().currentUser?.uid
                    
                    //save data to firebase
                    let todaydb = Database.database().reference().child(userid!).child(todayDateString)
                    
                    todaydb.child(String(finishedtask.id)).updateChildValues(["state": "true"])
                    
                    }
//
                }
            }
            
            //Reload tableView
            self.taskTableView.reloadData()
//            self.configureTableView()
            self.circleChanged()
        }
    
    
    func configureTableView(){
        taskTableView.rowHeight = UITableViewAutomaticDimension
        taskTableView.estimatedRowHeight = 240.0
        
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        taskInputTextField.endEditing(true)
    }
    
    //circle change function
    func circleChanged(){
        circle.font = UIFont.systemFont(ofSize: 70)
        
        circle.animationStyle = kCAMediaTimingFunctionLinear
        
        //get the all record of database

       
        let finishednum = taskArrFull.count - taskArr.count
        let allnum = taskArrFull.count
        if (!taskArrFull.isEmpty){
            print("haha")
            circle.setProgress(value: CGFloat(Double(finishednum)/Double(allnum)*100), animationDuration: 3, completion: nil)
        }else{
            circle.setProgress(value: CGFloat(0), animationDuration: 3, completion: nil)
        }

        print("taskarr : \(taskArr.count)")
        print("taskful : \(taskArrFull.count)")
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        taskInputTextField.endEditing(true)
        taskInputTextField.isEnabled = false
        addButton.isEnabled = false
        
        if !(taskInputTextField.text?.isEmpty)!{
            //get the today date, save it as database name
            
            let todayDateString = getTodayDate()
            let userid = Auth.auth().currentUser?.uid
            
            //save data to firebase
            let todaydb = Database.database().reference().child(userid!).child(todayDateString)
            
            let newid = taskArrFull.count + 1
            
            let inputString = taskInputTextField.text!
            let taskDic = ["taskInfo" : inputString, "state" : "false", "id": String(newid)]
            
            
            todaydb.child(String(newid)).setValue(taskDic){
                (error, reference) in
                if(error != nil){
                    print(error!)
                }else{
                    print("save date successfully")
                    self.addButton.isEnabled = true
                    self.taskInputTextField.isEnabled = true
                    self.taskInputTextField.text = ""
                    //
                    //                //
                    //
                    
                }
            }
            
            circleChanged()
        }else{
            taskInputTextField.isEnabled = true
            addButton.isEnabled = true
        }
        
       
        
    }
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            self.inputHeight.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.inputHeight.constant = 310
            self.view.layoutIfNeeded()
        }
        
    }
    
    func getTodayDate() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let someDateTime = formatter.string(from: date)
//
        
//        let someDateTime = "20171223"
        return someDateTime
        
    }
    
    
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
        
    }
    
    func loadtodaydata(){

        let todayDateString = getTodayDate()
        let userid = Auth.auth().currentUser?.uid
        
        //save data to firebase
        let todaydb = Database.database().reference().child(userid!).child(todayDateString)

        
        todaydb.observe(.childAdded){
            (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["taskInfo"]
            let state = snapshotValue["state"]
            let id = snapshotValue["id"]
            
            let newTask = Task(id : Int(id!)!, finished : Bool(state!)!, taskText : text!)
            
//            newTask.taskText = text!
//            newTask.finished = Bool(state!)!
//            newTask.id = Int(id!)!
            
            self.taskArrFull.append(newTask)
            
            if newTask.finished == false{
                self.taskArr.append(newTask)
            }
            
            self.configureTableView()
            self.circleChanged()
            self.taskTableView.reloadData()
        }

    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show()
        
        do{
            try Auth.auth().signOut()
            print("----------------")
            SVProgressHUD.dismiss()
            performSegue(withIdentifier: "gobackwelcome", sender: self)

        }catch{
            SVProgressHUD.dismiss()
            print("Something wrong here")
        }
    }
    

  
}
