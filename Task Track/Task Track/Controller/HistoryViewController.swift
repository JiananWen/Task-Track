//
//  HistoryViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/15/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class HistoryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    //store all date : tasks
    var taskswholearr : [String : [Task]] = [String : [Task]]()
    var tasksState : [String : Double] = [String : Double]()
    var datearr : [String] = [String]()
    

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        
        loadDateFromFirebase()
        
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        
        //TODO: Register your MessageCell.xib file here:
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle : nil), forCellReuseIdentifier: "historycell")
        
//        configureTableView()
        historyTableView.separatorStyle = .none
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datearr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryTableViewCell
        
        let newdate = datearr[indexPath.row]
        
        let percentage = tasksState[newdate]
        
//        cell.progressview.frame.size.width = view.frame.size.width * CGFloat(percentage!)
        
        if percentage! < 0.1 {
            cell.bartrailing.constant = UIScreen.main.bounds.size.width * 0.9
        }else{
            cell.bartrailing.constant = UIScreen.main.bounds.size.width * CGFloat(1 - percentage!)
        }
        
        cell.historyDateLabel.text = formatdate(inputdate: newdate)
        
        if (percentage! < 0.3){
            cell.progressview.backgroundColor = UIColor.flatRed()
        }else if( percentage! >= 0.3 && percentage! < 0.7){
            cell.progressview.backgroundColor = UIColor.flatYellow()
        }else{
            cell.progressview.backgroundColor = UIColor.flatGreen()
        }
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "detailviewcontroller") as! DetailViewController
        
        dvc.needDate = datearr[indexPath.row]
        
//        performSegue(withIdentifier: "historytodetail", sender: self)
        
        self.navigationController?.pushViewController(dvc, animated: true)

        
    }
    
    

    func loadDateFromFirebase(){
        
        let userid = Auth.auth().currentUser?.uid
        
        let mydb = Database.database().reference().child(userid!)
        
        //get all data
        mydb.observe(.value) { snapshot in
            
            
            if snapshot.childrenCount > 0{
                
                
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                    print(rest)
                    //here rest is the whole data that related to this user
//                    print(rest.key) //get date
                    
                    let date1 = rest.key
                    //get task information
                    var taskarr123 : [Task] = [Task]()
                    
                    for everytask in rest.children.allObjects as! [DataSnapshot]{
                        let taskobject = everytask.value as! [String : String]
                        
                        let taskinfo = taskobject["taskInfo"]
                        let taskid = taskobject["id"]
                        let taskstate = taskobject["state"]
                        
                        let newTask = Task(id : Int(taskid!)!, finished : Bool(taskstate!)!, taskText : taskinfo!)
                        
                        taskarr123.append(newTask)
                    }
                    
                    self.taskswholearr[date1] = taskarr123
                    
                    
                }

//                self.getDateArr()
                
                for (key, value) in self.taskswholearr {
                    var allnum = 0
                    var finishednum = 0
                    for task in value{
                        
                        allnum = allnum + 1
                        
                        if task.finished == true{
                            finishednum = finishednum + 1
                        }
                    }
                    
                    let percentage = Double(finishednum)/Double(allnum)
                    print("```````````````````")
                    print("key:\(key)")
                    print("per:\(percentage)")
                    
                    self.tasksState[key] = percentage
                    self.datearr.append(key)
                    print("ddddd")
                    print(self.tasksState.count)
                    print(self.datearr.count)
                    
                    self.datearr.sort()
                    
                    self.historyTableView.reloadData()
                }
            }
            
            
        }
        
        
    }
    
    func configureTableView(){
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.estimatedRowHeight = 240.0
        
    }
    
    func formatdate(inputdate : String) -> String{
        let dateString = inputdate // change to your date format
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let date = dateFormatter.date(from: dateString)
        
        
        let datefor1 = DateFormatter()
        datefor1.dateFormat = "MMM d, yyyy"
        
        let date1 = datefor1.string(from: date!)
        
        return date1
    }
    

}
