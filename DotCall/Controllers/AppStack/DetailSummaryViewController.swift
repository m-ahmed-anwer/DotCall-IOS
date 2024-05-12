//
//  DetailSummaryViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit

class DetailSummaryViewController: UIViewController {

//    var summary: Summary?
//       
//    init(summary: Summary) {
//       self.summary = summary
//       super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//       fatalError("init(coder:) has not been implemented")
//    }

    var currentSegmentIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        
        
        tableView.register(UINib(nibName: "TranscriptionCell", bundle: nil), forCellReuseIdentifier: "TranscriptionCell")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        currentSegmentIndex = sender.selectedSegmentIndex
        generator.impactOccurred()
        tableView.reloadData()
        
    }
    

}


extension DetailSummaryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedOutlet.selectedSegmentIndex {
               case 0:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptionCell", for: indexPath) as! TranscriptionCell
                   
                   return cell
               case 1:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptionCell", for: indexPath) as! TranscriptionCell
                    cell.time?.text  = "00.00.12"
                    cell.speakerName?.text  = "Ahmed Anwer"
                   cell.transcriptionText?.text  = "Content for segment 0"
                   return cell
               case 2:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptionCell", for: indexPath) as! TranscriptionCell
            
                   cell.transcriptionText?.text  = "Content for segment 2"
                   return cell
               case 3:
                   let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseContact", for: indexPath) as! ContactCell
                    cell.contactName?.text  = "Ahmed Anwer"
            cell.view.backgroundColor = UIColor.background
            
                   return cell
               default:
                   fatalError("Unexpected segment index")
               }
    }
}

extension DetailSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor.background

        let titleLabel = UILabel(frame: CGRect(x: 12, y: 0, width: headerView.frame.size.width - 30, height: headerView.frame.size.height))
        
        switch currentSegmentIndex {
        case 0:
           titleLabel.text = "Recording"
        case 1:
           titleLabel.text = "Transcription"
        case 2:
           titleLabel.text = "Summary"
        case 3:
           titleLabel.text = "Participants"
        default:
           break
        }
        titleLabel.textColor = UIColor.themeText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerView.addSubview(titleLabel)

        return headerView
    }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
}
