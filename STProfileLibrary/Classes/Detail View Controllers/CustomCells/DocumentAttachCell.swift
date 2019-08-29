//
//  DocumentAttachCell.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 8/22/19.
//

import UIKit

class DocumentAttachCell: UITableViewCell {
  @IBOutlet weak var doc_view: BaseDocumentPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
