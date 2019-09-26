//
//  PrefrerencePopupVC.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 9/25/19.
//

import UIKit
import Alamofire

class PrefrerencePopupVC: BaseProfileVC {
    @IBOutlet weak var crossBtn:UIButton!
    @IBOutlet weak var footrView: UIView!
    @IBOutlet weak var tblView: UITableView!
    var titleStr:String?
    @IBOutlet weak var lblTitle: UILabel!
    var objPref:PrefTypeList!
     var prefDetail = [PrefDetailClone]()
     var prefDetailForSave = [PrefDetail]()
    var LOOKUP_TYPE_IDG = ""
    weak var updateDelegate:UpdateVacationDelegation!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let LTiD = objPref.LOOKUP_TYPE_ID,let ttl =  objPref.LOOKUP_TYPE {
            LOOKUP_TYPE_IDG = LTiD
            self.lblTitle.text = ttl
        }
         self.tblView.tableFooterView = footrView
   
        for item in objPref!.DETAIL! {
            let objClone = PrefDetailClone(LOOKUP_TYPE_ID: item.LOOKUP_TYPE_ID ?? "", LOOKUP_ID: item.LOOKUP_ID ?? "", LOOKUP_CODE: item.LOOKUP_CODE ?? "", LOOKUP_MEANING: item.LOOKUP_MEANING ?? "", SELECTED: item.SELECTED ?? "")
           prefDetail.append(objClone)
            
        }
        if let obj = objPref?.DETAIL{
        prefDetailForSave = obj
        }
        let image1 = UIImage(named: "acount_cross_error")
        self.crossBtn.setImage(image1, for: .selected)
        self.crossBtn.setImage(image1, for: .normal)
        self.crossBtn.setImage(image1, for: .highlighted)
        // Do any additional setup after loading the view.
    }
    @IBAction func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func checkRadioClk(_ sender:UIButton){
        
        
        var freshArr = [PrefDetailClone]()
        if sender.isSelected {
            
        }
        else {
            sender.isSelected = true
        }
        
        
        let objDetail = self.prefDetail[sender.tag]
        
        for item in self.prefDetail {
            var itm = item
            
            if item.LOOKUP_ID == objDetail.LOOKUP_ID {
                
                itm.SELECTED = "Y"
                
            }
            else {
                itm.SELECTED = "N"
            }
            
            
            freshArr.append(itm)
            
        }
        self.prefDetail = freshArr
        tblView.reloadData()

    }
    @objc func checkBoxClk(_ sender: UIButton){
        
        var freshArr = [PrefDetailClone]()
        
        sender.isSelected = !sender.isSelected
        
        
        let objDetail = self.prefDetail[sender.tag]
        
        for item in self.prefDetail {
            var itm = item
            // let item = item1.copy() as! PrefDetail
            
            if item.LOOKUP_ID == objDetail.LOOKUP_ID {
                
                if sender.isSelected == true {
                    itm.SELECTED = "Y"
                }
                else {
                    itm.SELECTED = "N"
                }
            }
            
            
            freshArr.append(itm)
            
        }
        self.prefDetail = freshArr
        
        
        tblView.reloadData()
    }
    @IBAction func SaveClicked() {
         let postParamHeaders = [String: String]()
        var params = Parameters()
        var lookup_ids = ""
        var lookup_type_ids = ""
        var arr_lookup_ids = [String]()
        var arr_lookup_type_ids = [String]()
        for obj in self.prefDetail {
            
            if obj.SELECTED! == "Y" {
                arr_lookup_ids.append(obj.LOOKUP_ID!)
                arr_lookup_type_ids.append(obj.LOOKUP_TYPE_ID!)
            }
            
        }
        
        lookup_ids = arr_lookup_ids.joined(separator: ",")
        lookup_type_ids = arr_lookup_type_ids.joined(separator: ",")
        
        if lookup_type_ids.count < 1 {
            
            lookup_type_ids = LOOKUP_TYPE_IDG
        }
        
        params["LOOKUP_ID"] = lookup_ids
        params["LOOKUP_TYPE_ID"] = lookup_type_ids
        ServerCommunication.getDataWithGetWithDataResponse(url: "store_preference", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success:{ (successResponseData) in
            if successResponseData.data != nil {
                if let json = successResponseData.result.value as? NSDictionary {
                    if let dic = json["data"] as? NSDictionary {
                        if let vId = dic.value(forKey: "USER_PREF_ID") as? String {
                            if vId.contains("ALREADY") {
                                DataUtil.alertMessage("Preference rule for define give data is already exist!!", viewController: self)
                                
                            }
                            else {
                                self.updateUIForSave()
                                // DataUtil.alertMessage("Data saved successfully", viewController: self)
                            }
                        }
                        else {
                            self.updateUIForSave()
                        }
                        
                    }
                    
                }
            }
            else {
                
                
                
            }
            
        }, failure: { (successResponseDataerr) in
            
        })

    }
    func updateUIForSave() {
        
        var freshArr = [PrefDetail]()
        var i = 0
        
        for item in self.prefDetailForSave {
            // var itm = item
            
            item.SELECTED = self.prefDetail[i].SELECTED
            
            freshArr.append(item)
            // self.prefDetailForSave[i].SELECTED  = "Y"
            i = i + 1
        }
        
        self.prefDetailForSave = freshArr
        self.updateDelegate.updatevacationRule(isUpdate: true)
        self.dismiss(animated: true, completion: nil)
    }

}
extension PrefrerencePopupVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return prefDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objDetail = prefDetail[indexPath.row]
        if ( objPref.SELECTION_TYPE ?? "" == "C"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreferenceCell", for: indexPath) as! PreferenceCell
            
            //   let obj = filterArr[indexPath.row];
            let tmpLookupTypeId = objDetail.LOOKUP_ID
            let lookupmeaning = objDetail.LOOKUP_MEANING
            
            let lookupcode = objDetail.LOOKUP_CODE
            
            if let code = lookupcode, let mean = lookupmeaning {
                
                cell.lookupTxt.text =  mean
                
            }
            else {
                cell.lookupTxt.text = ""
            }
            
            //   if let typeId = tmpLookupTypeId {
            // cell.checkBut.isSelected = self.checkInPreference(id: typeId)
            //   }
            if let selected = objDetail.SELECTED {
                
                if selected == "Y" {
                    
                    cell.checkBut.isSelected = true
                    
                }
                else {
                    cell.checkBut.isSelected = false
                }
            }
            else {
                cell.checkBut.isSelected = false
            }
            
            
            cell.checkBut.tag = indexPath.row
            cell.checkBut.addTarget(self, action: #selector(checkBoxClk(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreferenceRadioCell", for: indexPath) as! PreferenceRadioCell
            
            //   let obj = filterArr[indexPath.row];
            let lookupmeaning = objDetail.LOOKUP_MEANING
            let lookupcode = objDetail.LOOKUP_CODE
            
            if let code = lookupcode, let mean = lookupmeaning {
                cell.lookupTxt.text =  mean
            }
            if let selected = objDetail.SELECTED {
                
                if selected == "Y" {
                    
                    cell.checkBut.isSelected = true
                    
                }
                else {
                    cell.checkBut.isSelected = false
                }
            }
            else {
                cell.checkBut.isSelected = false
            }
            
            
            cell.checkBut.tag = indexPath.row
            cell.checkBut.addTarget(self, action: #selector(checkRadioClk(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
}

class PreferenceCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    var titleStr:String?
    @IBOutlet weak var checkBut: UIButton!
    @IBOutlet weak var lookupTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "blackemptycheck.png")
        let imageSel = UIImage(named: "blackcheckfill.png")
        self.checkBut.setImage(image, for: .normal)
        self.checkBut.setImage(imageSel, for: .selected)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class PreferenceRadioCell: UITableViewCell {
    @IBOutlet weak var checkBut: UIButton!
    @IBOutlet weak var lookupTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         let image = UIImage(named: "radioempty.png")
        let imageSel = UIImage(named: "dotradio.png")
        self.checkBut.setImage(image, for: .normal)
        self.checkBut.setImage(imageSel, for: .selected)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
