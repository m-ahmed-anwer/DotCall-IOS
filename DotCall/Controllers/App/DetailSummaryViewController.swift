//
//  DetailSummaryViewController.swift
//  DotCall
//
//  Created by Ahmed Anwer on 2024-05-07.
//

import UIKit
import RealmSwift

class DetailSummaryViewController: UIViewController {

    // MARK: - Properties

    private let realm = try! Realm()
    internal var detailedSummary: Summary?
    private var currentSegmentIndex: Int = 0

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - View Lifecycle

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
        setupTableView()
        updateUI()
    }

    // MARK: - Button Actions

    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        hapticImpact()
        currentSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    @objc func profileButtonPressed(_ sender: UIButton) {
        hapticImpact()
        if let detailedSummary = detailedSummary{
            let callStoryboard = UIStoryboard(name: "AppStoryboard", bundle: nil)
            if let callViewController = callStoryboard.instantiateViewController(withIdentifier: "ContactProfiletoCheck") as? ContactProfileViewController {
                // Set the contact name and image
                //callViewController.contactPhone = "\(detailedSummary.callReciverPhoneNum)"
                callViewController.contactName = "\(detailedSummary.callReciverName)"
                callViewController.contactUsername = "\(detailedSummary.callReciverUsername)"
                callViewController.hidesBottomBarWhenPushed = true
                
                // Push the callViewController
                navigationController!.pushViewController(callViewController, animated: true)
            }
        }
    }
    
    @objc func currentUserProfileButtonPressed(_ sender: UIButton) {
        hapticImpact()
        if let tabViewController = UIApplication.shared.keyWindow?.rootViewController as? TabViewController {
            tabViewController.navigateToSettings()
        }
    }

    

}

// MARK: - Table View Data Source

extension DetailSummaryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedOutlet.selectedSegmentIndex {
        case 0: return 1
        case 1: return 1
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
                 cell.time?.text  = "00.00.14"
                cell.transcriptionText?.text  = "\(detailedSummary?.transcription ?? "null")"
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCheck", for: indexPath) as! SummaryViewCell
            cell.summaryTitle?.text  = "\(detailedSummary?.summaryTitle ?? "null")"
            cell.summaryText?.text  = "\(detailedSummary?.summaryDetail ?? "null")"
           cell.summaryTopic?.text  = "The key topics in the conversation were: \(detailedSummary?.summaryTopic ?? "null")"
                 return cell
                
            case 3:
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.profileButton.addTarget(self, action: #selector(currentUserProfileButtonPressed(_:)), for: .touchUpInside)
                    cell.contactName?.text  = "\(UserProfile.shared.generalProfile.name ?? "") (You)"
                    return cell
                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ParticpantsCheck", for: indexPath) as! ParticipantViewCell
                    cell.contactName?.text  = "\(detailedSummary?.callReciverName ?? "Nill")"
                    cell.profileButton.addTarget(self, action: #selector(profileButtonPressed(_:)), for: .touchUpInside)
                    return cell
                }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .background

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.textColor = .themeText

        switch currentSegmentIndex {
        case 0: title.text = "Recording"
        case 1: title.text = "Transcription"
        case 2: title.text = "Summary"
        case 3: title.text = "Participants"
        default: title.text = ""
        }

        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - Table View Delegate

extension DetailSummaryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}

// MARK: - Private Methods

private extension DetailSummaryViewController{
    private func setupTableView() {
        tableView.register(UINib(nibName: "RecordViewCell", bundle: nil), forCellReuseIdentifier: "RecordtoCheck")
        tableView.register(UINib(nibName: "TranscriptionCell", bundle: nil), forCellReuseIdentifier: "TranscriptionCell")
        tableView.register(UINib(nibName: "SummaryViewCell", bundle: nil), forCellReuseIdentifier: "SummaryCheck")
        tableView.register(UINib(nibName: "ParticipantViewCell", bundle: nil), forCellReuseIdentifier: "ParticpantsCheck")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ReuseContact")
    }

    private func updateUI() {
        if let detailedSummary = detailedSummary {
            titleLabel.text = detailedSummary.summaryTitle

            if let time = detailedSummary.time {
                // Format time based on different scenarios
                timeLabel.text = formattedTimeString(from: time)
            } else {
                timeLabel.text = "NaN"
            }
        } else {
            titleLabel.text = "NaN"
            timeLabel.text = "NaN"
        }
    }

    private func formattedTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        let now = Date()

        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Today \(dateFormatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return "Yesterday \(dateFormatter.string(from: date))"
        } else if now.timeIntervalSince(date) < TimeInterval(7 * 24 * 3600) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            return formatter.string(from: date, to: now) ?? ""
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: date)
        }
    }
    
    private func hapticImpact(){
        if UserProfile.shared.settingsProfile.haptic == true {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
