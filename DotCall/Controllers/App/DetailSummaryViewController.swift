//
//  DetailSummaryViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit
import RealmSwift

class DetailSummaryViewController: UIViewController {

    
    let realm = try! Realm()
    
    var detailedSumary: Summary?
    
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
    
    
    func loadSummary(){
        
        //tableView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        tableView.register(UINib(nibName: "RecordViewCell", bundle: nil), forCellReuseIdentifier: "RecordtoCheck")
        tableView.register(UINib(nibName: "TranscriptionCell", bundle: nil), forCellReuseIdentifier: "TranscriptionCell")
        tableView.register(UINib(nibName: "SummaryViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCheck")
        tableView.register(UINib(nibName: "ParticipantViewCell", bundle: nil), forCellReuseIdentifier: "ParticpantsCheck")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
        
        
        if let detailedSummary = detailedSumary {
            titleLabel.text = detailedSummary.summaryTopic 
            
            if let time = detailedSummary.time {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                
                let now = Date()
                let calendar = Calendar.current
                if calendar.isDateInToday(time) {
                    dateFormatter.dateFormat = "HH:mm"
                    timeLabel.text = "Today \(dateFormatter.string(from: time))"
                } else if calendar.isDateInYesterday(time) {
                    dateFormatter.dateFormat = "HH:mm"
                    timeLabel.text = "Yesterday \(dateFormatter.string(from: time))"
                } else if now.timeIntervalSince(time) < TimeInterval(7 * 24 * 3600) {
                    let timeString = formatter.string(from: time, to: now) ?? ""
                    dateFormatter.dateFormat = "HH:mm"
                    timeLabel.text = "\(timeString)"
                } else {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    timeLabel.text = dateFormatter.string(from: time)
                }
            } else {
                timeLabel.text = "NaN"
            }
        } else {
            titleLabel.text = "NaN"
            timeLabel.text = "NaN"
        }

        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        currentSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
        
    }
    

}


extension DetailSummaryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedOutlet.selectedSegmentIndex {
            case 0: return 1
            case 1: return 5
            case 2: return 1
            case 3: return 2
            default: return 0
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch segmentedOutlet.selectedSegmentIndex {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordtoCheck", for: indexPath) as! RecordViewCell
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptionCell", for: indexPath) as! TranscriptionCell
                 cell.time?.text  = "00.00.12"
                 cell.speakerName?.text  = "Ahmed Anwer"
                cell.transcriptionText?.text  = "Content for segment 0"
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCheck", for: indexPath) as! SummaryViewCell
            cell.summaryTitle?.text  = "\(detailedSumary?.summaryTopic ?? "null")"
            cell.summaryText?.text  = "\(detailedSumary?.summaryDetail ?? "null")"
                 return cell
                
            case 3:
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.profileButton.addTarget(self, action: #selector(currentUserProfileButtonPressed(_:)), for: .touchUpInside)
                    cell.contactName?.text  = "\(UserProfile.shared.generalProfile.name ?? "") (You)"
                    return cell
                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.contactName?.text  = "\(detailedSumary?.callReciverName ?? "Nill")"
                    cell.profileButton.addTarget(self, action: #selector(profileButtonPressed(_:)), for: .touchUpInside)
                    return cell
                }
          
                
        default:
            return UITableViewCell()
        }
    }
    
    @objc func profileButtonPressed(_ sender: UIButton) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        let callStoryboard = UIStoryboard(name: "AppStoryboard", bundle: nil)
        if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "ContactProfiletoCheck") as? ContactProfileViewController {
            
            // Set the contact name and image
            callViewController.contactPhone = "0768242884"
            callViewController.contactName = "Ahmed Anwer"
            callViewController.hidesBottomBarWhenPushed = true
            
            // Push the callViewController
            navigationController!.pushViewController(callViewController, animated: true)
        }
    }
    
    @objc func currentUserProfileButtonPressed(_ sender: UIButton) {
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let tabViewController = nextResponder as? TabViewController {
                tabViewController.navigateToSettings()
                break
            }
            responder = nextResponder
        }
    }
    
    
}

extension DetailSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .background

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textColor = .themeText
        
        switch currentSegmentIndex {
        case 0:
            title.text = "Recording"
            view.addSubview(title)
        case 1:
            title.text = "Transcription"
            view.addSubview(title)
        case 2:
            title.text = "Summary"
            view.addSubview(title)
        case 3:
            title.text = "Participants"
            view.addSubview(title)
        default:
            title.text = ""
            view.addSubview(title)
        }
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        

        return view
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}




