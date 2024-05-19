//
//  SummarybyContactViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-18.
//

import UIKit

class SummarybyContactViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backButton]
        navigationController?.navigationBar.tintColor = UIColor.backButton
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "SummaryByContactViewCell", bundle: nil), forCellReuseIdentifier: "SummaryByContact")
        
        navigationItem.title = "Ahmed Anwer"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    

}
extension SummarybyContactViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryByContact", for: indexPath) as! SummaryByContactViewCell
        cell.timeText.text = "123/12/312 10.00.P.M"
        cell.titleText.text = "Title Goes here"
        return cell
    }
}

extension SummarybyContactViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
      
        performSegue(withIdentifier: "DetailtoSummaryCheck", sender: nil)
    }
    
}
