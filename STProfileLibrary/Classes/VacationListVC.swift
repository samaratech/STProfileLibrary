//
//  VacationListVC.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/25/19.
//  Copyright © 2019 learning. All rights reserved.

import UIKit

import Alamofire

class VacationListVC: BaseProfileVC {
    @IBOutlet weak var tblView: UITableView!
    var listDataArr = [VacationList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacation"
        headerViewP.setBasicHeight(height: 0)
        basicViewHeight.constant = 185
        headerViewP.plusBtb.isSelected = true
        tblView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        self.tblView.rowHeight = UITableView.automaticDimension;
        self.tblView.estimatedRowHeight = 200;
        self.getData()
    }
    
    func getData() {
        let params:Parameters =  ["ORG_ID": "93", "SIGNIN_TYPE": "P", "TOKEN": "92b2ae6292946dcd6caee78496d98065", "LOCATION_ID": "66"]
        
        let postParamHeaders = [String: String]()
        
        ServerCommunication.getDataWithGetWithDataResponse(url: "getVacationUserHistory", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    
                    let serviceResponse = try decoder.decode(VacationData.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let arr = serviceResponse.data {
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
extension VacationListVC: UITableViewDataSource, UITableViewDelegate {
    @objc func openOptionsforCell(btn: UIButton) {
        let obj = self.listDataArr[btn.tag]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title:"Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title:"Delete", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if let recordId = obj.USER_VAC_ID {
                self.removePassport(type: "VACATION", recordId: recordId, success: { (str) in
                    self.listDataArr.remove(at: btn.tag)
                    self.tblView.reloadData()
                    if self.listDataArr.count < 1 {
                        self.noDataFoundView.isHidden = false
                    }
                    else {
                        self.noDataFoundView.isHidden = true
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
        }))
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        present(alert, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VacationCell") as! VacationCell
        cell.setInfoData(self.listDataArr[indexPath.row])
        cell.btnthreeDots.tag = indexPath.row
        cell.btnthreeDots.addTarget(self, action: #selector(openOptionsforCell(btn:)), for: .touchUpInside)
        return cell
    }
}

class VacationCell: UITableViewCell {
    @IBOutlet weak var btnthreeDots: UIButton!
    @IBOutlet weak var lblVacationDesc: UILabel!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblForwardedTo: UILabel!

    var InfoList:VacationList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setInfoData(_ cellInfo: VacationList) {
        self.InfoList = cellInfo
        if let Info =  self.InfoList {
            if let text = Info.PURPOSE_COMMENT {
                self.lblVacationDesc.text = text
            }
            if let name = Info.EMP_NAME {
                self.lblForwardedTo.text = name
            }
            if let date = Info.START_DATE {
                self.lblStartDate.text = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.UI_DATE_FORMAT)
            }
            if let date = Info.END_DATE {
                self.lblEndDate.text = DateUtil.convertDate(stringDate: date, stringDateFormat: DateUtil.TA_DATE_FORMAT, reqDateFormat: DateUtil.UI_DATE_FORMAT)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}







