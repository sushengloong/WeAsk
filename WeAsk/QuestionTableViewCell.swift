//
//  QuestionTableViewCell.swift
//  WeAsk
//
//  Created by Sheng Loong Su on 1/4/19.
//  Copyright © 2019 ShengLoong Su. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
