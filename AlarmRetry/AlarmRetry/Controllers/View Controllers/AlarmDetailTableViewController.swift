//
//  AlarmDetailTableViewController.swift
//  AlarmRetry
//
//  Created by Anthroman on 3/3/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var timeDisplay: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enabledButtonLabel: UIButton!
    
    var alarmIsOn: Bool = true
    
    var alarm: Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        updateViews()
    }
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        timeDisplay.date = alarm.fireDate
        alarmNameTextField.text = alarm.name
        if self.alarmIsOn {
            enabledButtonLabel.setTitle("Disable", for: .normal)
            enabledButtonLabel.backgroundColor = .red
        } else {
            enabledButtonLabel.setTitle("Enable", for: .normal)
            enabledButtonLabel.backgroundColor = .green
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        alarmIsOn = !alarmIsOn
        guard let alarm = alarm else {return}
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let timeDisplay = timeDisplay?.date, let alarmNameTextField = alarmNameTextField.text, let enabledButtonLabel = enabledButtonLabel?.isEnabled else {return}
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: timeDisplay, name: alarmNameTextField, enabled: enabledButtonLabel)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: timeDisplay, name: alarmNameTextField, enabled: enabledButtonLabel)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
