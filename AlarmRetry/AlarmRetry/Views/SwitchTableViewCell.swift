//
//  SwitchTableViewCell.swift
//  AlarmRetry
//
//  Created by Anthroman on 3/3/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func alarmSwitchTapped(cell: SwitchTableViewCell, isSet: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.alarmSwitchTapped(cell: self, isSet: alarmSwitch.isOn)
    }
    
    func updateViews() {
        guard let alarm = alarm else {return}
        timeLabel.text = alarm.fireDate.formatted
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
}
