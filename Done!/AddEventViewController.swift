//
//  AddEventViewController.swift
//  Done!
//
//  Created by Yongyang Nie on 10/21/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

import UIKit
import Eureka

class AddEventViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func initializeForm() {
        
        form +++
            
            TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< TextRow("Location").cellSetup {
                $1.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            PushRow<EventAlert>() {
                $0.title = "Alert"
                $0.options = EventAlert.allValues
                $0.value = .Never
                }
                .onChange { [weak self] row in
                    if row.value == .Never {
                        if let second : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert"), let secondIndexPath = second.indexPath {
                            row.section?.remove(at: secondIndexPath.row)
                        }
                    }
                    else{
                        guard let _ : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert") else {
                            let second = PushRow<EventAlert>("Another Alert") {
                                $0.title = $0.tag
                                $0.value = .Never
                                $0.options = EventAlert.allValues
                            }
                            row.section?.insert(second, at: row.indexPath!.row + 1)
                            return
                        }
                    }
            }
            
            <<< DateTimeInlineRow("Due Date") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow {cell, row, inlineRow in
                    inlineRow.cellUpdate() { cell, row in
                        cell.datePicker.datePickerMode = .dateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
        
        form +++
            
            PushRow<RepeatInterval>("Repeat") {
                $0.title = $0.tag
                $0.options = RepeatInterval.allValues
                $0.value = .Never
                }.onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
        
        form +++
            
            URLRow("URL") {
                $0.placeholder = "URL"
            }
            
            <<< TextAreaRow("notes") {
                $0.placeholder = "Notes"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
        }
        
    }
    
    @IBAction func cancelTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    enum RepeatInterval : String, CustomStringConvertible {
        case Never = "Never"
        case Every_Day = "Every Day"
        case Every_Week = "Every Week"
        case Every_2_Weeks = "Every 2 Weeks"
        case Every_Month = "Every Month"
        case Every_Year = "Every Year"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, Every_Day, Every_Week, Every_2_Weeks, Every_Month, Every_Year]
    }
    
    enum EventAlert : String, CustomStringConvertible {
        case Never = "None"
        case At_time_of_event = "At time of event"
        case Five_Minutes = "5 minutes before"
        case FifTeen_Minutes = "15 minutes before"
        case Half_Hour = "30 minutes before"
        case One_Hour = "1 hour before"
        case Two_Hour = "2 hours before"
        case One_Day = "1 day before"
        case Two_Days = "2 days before"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, At_time_of_event, Five_Minutes, FifTeen_Minutes, Half_Hour, One_Hour, Two_Hour, One_Day, Two_Days]
    }
    
    enum EventState {
        case busy
        case free
        
        static let allValues = [busy, free]
    }
}

