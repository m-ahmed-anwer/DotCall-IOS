//
//  RecentCallViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//
import FirebaseAuth
import UIKit

class RecentCallViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UINib(nibName: "RecentCallCell", bundle: nil), forCellReuseIdentifier: "RecentCell")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("sign out successfully")
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    


}




extension RecentCallViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //recentCall.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier:  "RecentCell", for: indexPath) as! RecentCallCell
        
        cell.backgroundColor = .iosBoxBG
        
        return cell
    }



}

extension RecentCallViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
}
