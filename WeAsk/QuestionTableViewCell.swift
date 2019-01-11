//
//  QuestionTableViewCell.swift
//  WeAsk
//
//  Created by Sheng Loong Su on 1/4/19.
//  Copyright © 2019 ShengLoong Su. All rights reserved.
//

import UIKit

protocol QuestionCellDeleteButtonDelegate{
    func deleteTapped(at index:IndexPath)
}

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextView: UITextView!
    
    var delegate: QuestionCellDeleteButtonDelegate!
    var indexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteTapped(_ sender: Any) {
        self.delegate?.deleteTapped(at: indexPath)
    }
    
}
