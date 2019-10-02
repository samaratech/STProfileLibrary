//
//  PreferenceListVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/25/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit
import Alamofire

class PreferenceListVC: BaseProfileVC {
    var titleStr:String?
    @IBOutlet weak var tblView: UITableView!
    var listDataArr = [PrefTypeList]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // self.automaticallyAdjustsScrollViewInsets = false
       // self.tblView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.title = titleStr ?? "Preference"
        headerViewP.setBasicHeight(height: 0)
        basicViewHeight.constant = 185
        headerViewP.plusBtb.isSelected = true
   
        self.tblView.rowHeight = UITableView.automaticDimension;
        self.tblView.estimatedRowHeight = 200;
        self.perform(#selector(getData), with: nil)
       // self.getData()
        let imageback = UIImage(named: "acount_back_arrow")
        let button1 = UIBarButtonItem(image:imageback, style: .plain, target: self, action: #selector(backBtnClicked))
        self.navigationItem.leftBarButtonItem  = button1
        
    }
    @objc func backBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getData() {
        let params:Parameters =  ["ORG_ID": "93", "SIGNIN_TYPE": "P", "TOKEN": "92b2ae6292946dcd6caee78496d98065", "LOCATION_ID": "66"]
        
        let postParamHeaders = [String: String]()
        
        ServerCommunication.getDataWithGetWithDataResponse(url: "getPreferenceDetail", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    
                    let serviceResponse = try decoder.decode(PreferenceData.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let arr = serviceResponse.data?.types {
                            self.listDataArr = arr
                        }
                        
                        print("self.licenseListDataArr ==",self.listDataArr)
                        if self.listDataArr.count < 1 {
                            self.noDataFoundView.isHidden = false
                        }
                        else {
                            self.noDataFoundView.isHidden = true
                        }
                        self.tblView.reloadData()
                    }
                    else {
                        if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                            
                            if let msg = dictFailure["message"] as? String
                            {
                                DataUtil.alertMessage(msg , viewController: self)
                            }
                        }
                    }
                } catch let jsonError {
                    print("jsonError ===",jsonError)
                }
            }
            else {
            }
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                DataUtil.alertMessage(msg as! String, viewController: self)
            }
        }
    }
}
extension PreferenceListVC: UITableViewDataSource, UITableViewDelegate,UpdateVacationDelegation {
    func updatevacationRule(isUpdate: Bool) {
        if isUpdate == true {
            
        }
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferenceTypeCell") as! PreferenceTypeCell
        cell.setInfoData(self.listDataArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let objPref = self.listDataArr[indexPath.row]
        let podBundle = Bundle(for: PrefrerencePopupVC.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        
        let obj = story.instantiateViewController(withIdentifier: "PrefrerencePopupVC") as! PrefrerencePopupVC
        
        obj.objPref = objPref
        obj.titleStr = self.titleStr
        obj.updateDelegate = self
         self.present(obj, animated: true, completion: nil)
        //self.navigationController?.pushViewController(obj, animated: true)
    }
}

class PreferenceTypeCell: UITableViewCell {
    @IBOutlet weak var viewpref: UIView!
    @IBOutlet weak var typeTxt: UILabel!
     @IBOutlet weak var arrowBtn: UIButton!
   
    var InfoList:PrefTypeList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "acount_arrow-point-to-right")
        self.arrowBtn.setImage(image, for: .selected)
        self.arrowBtn.setImage(image, for: .normal)
        self.arrowBtn.setImage(image, for: .highlighted)
        // Initialization code
    }
    func setInfoData(_ cellInfo: PrefTypeList) {
        self.viewpref.layer.borderWidth = 1
        self.viewpref.layer.borderColor = UIColor.lightGray.cgColor
        self.InfoList = cellInfo
        if let Info =  self.InfoList {
            if let text = Info.LOOKUP_TYPE {
                self.typeTxt.text = text
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}



