//
//  TodoListCell.swift
//  TodoList
//
//  Created by Savva on 01.01.2021.
//

import UIKit

class TodoListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(note: Note) {
        titleLabel.text = note.title
        descriptionLabel.text = note.description
        dateLabel.text = convertDate(date: note.date)
    }
    
    private func convertDate(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let parser = DateFormatter()
        parser.dateStyle = .medium
        return parser.string(from: date)
    }
}
