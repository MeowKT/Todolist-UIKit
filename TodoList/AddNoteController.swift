//
//  AddNoteController.swift
//  TodoList
//
//  Created by Savva on 01.01.2021.
//

import UIKit

class AddNoteController: UITableViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var note: Note?
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    let toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: false)
        return toolBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.inputView = datePicker
        dateLabel.inputAccessoryView = toolBar
        
        updateUI()
        updateDoneState()
    }
    
    @objc private func dateDone() {
        dateLabel.text = convertDate(date: datePicker.date)
        dateLabel.resignFirstResponder()
        updateDoneState()
    }
    
    private func convertDate(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let parser = DateFormatter()
        parser.dateStyle = .medium
        return parser.string(from: date)
    }
    
    private func updateUI() {
        titleLabel.text = note?.title ?? ""
        descriptionLabel.text = note?.description ?? ""
        dateLabel.text = convertDate(date: note?.date)
    }
    
    private func updateDoneState() {
        let titleText = titleLabel.text ?? ""
        let descriptionText = descriptionLabel.text ?? ""
        let dateText = dateLabel.text ?? ""
        
        doneButton.isEnabled = !titleText.isEmpty && !descriptionText.isEmpty && !dateText.isEmpty
    }
    
    @IBAction func editTextLabel(_ sender: Any) {
        updateDoneState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else {
            return
        }
        let title = titleLabel.text ?? ""
        let description = descriptionLabel.text ?? ""
        note = Note(title: title, description: description, date: datePicker.date)
    }
}
