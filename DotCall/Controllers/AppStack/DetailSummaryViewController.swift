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
        
        
        
        tableView.register(UINib(nibName: "RecordViewCell", bundle: nil), forCellReuseIdentifier: "RecordtoCheck")
        tableView.register(UINib(nibName: "TranscriptionCell", bundle: nil), forCellReuseIdentifier: "TranscriptionCell")
        tableView.register(UINib(nibName: "SummaryViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCheck")
        tableView.register(UINib(nibName: "ParticipantViewCell", bundle: nil), forCellReuseIdentifier: "ParticpantsCheck")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
        
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
                 cell.summaryTitle?.text  = "Hello this is the Title here"
                 cell.summaryText?.text  = "Hello welcome to my youtube channel guyzzz, how are you ok now you just go and  do your work now go back to work buddy bye bye"
                 return cell
                
            case 3:
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.profileButton.addTarget(self, action: #selector(currentUserProfileButtonPressed(_:)), for: .touchUpInside)
                    cell.contactName?.text  = "\(UserProfile.shared.generalProfile.name ?? "") (You)"
                    return cell
                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.contactName?.text  = "Mohamed"
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




