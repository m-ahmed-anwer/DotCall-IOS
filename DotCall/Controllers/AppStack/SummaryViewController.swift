//
//  HomeViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-02.
//

import UIKit

class SummaryViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var summaries: [Summary] = [
        Summary(callMaker: "+94768242884", callReciver: "+94768242884", time: "12.30.p.m", title: "Ahmed Anwer How are you aim  ada asd asd asd asd a s dasd asdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you aima  daa sd asd asd asd as d asd a sdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you aimadaasd asd asd asd as da sd asd sad asd asdasd", summary: "tion"),
        Summary(callMaker: "+94768242884", callReciver: "+94768242884", time: "12.30.p.m", title: "Ahmed Anwer How are you aim ad a asd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you ai m ad aasd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "+94768242884", time: "12.30.p.m", title: "Ahmed Anwer How are you a imada asd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "+94768242884", callReciver: "+94768242884", time: "12.30.p.m", title: "Ahmed Anwer How are you aimadaasd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you aimadaasd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you aimadaasd asd asd asd as dasdasdsad asd asdasd", summary: "tion"),
        Summary(callMaker: "Ahmed", callReciver: "Anwer", time: "12.30.p.m", title: "Ahmed Anwer How are you aimadaasd asd asd asd as dasdasdsad asd asdasd", summary: "tion")
        
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "SummarizeCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tabBarController?.delegate = self
    }
    
    

}



extension SummaryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier:  "ReusableCell", for: indexPath) as! SummarizeCell
        cell.summarizeTitleText?.text  = summaries[indexPath.row].title
        cell.callTimeText?.text  = summaries[indexPath.row].time
        cell.callRecieverText?.text  = summaries[indexPath.row].callReciver
        
        cell.selectionStyle = .gray
        return cell
    }
}

extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSummary = summaries[indexPath.row]

        performSegue(withIdentifier: "DetailtoSummaryCheck", sender: nil)
    }
    
    
}
extension SummaryViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Give haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
}
