//
//  ViewController.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/22/19.
//  Copyright © 2019 learning. All rights reserved.
//fdfdgdgdhdf

import UIKit
import Alamofire

public class HomeProfileVC: BaseProfileVC {
    public var baseUrl_home: String?
    public var LOCATION_ID_home: String?
    public var ORG_ID_home: String?
    public var SIGNIN_TYPE_home: String?
    public var TOKEN_home: String?
    
@IBOutlet weak var profileCollectioView:UICollectionView!
    var LookUpsTypeArr = [ProfileLookupType]()

  
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let baseUrl = baseUrl_home {
            baseUrl_profile = baseUrl
        }
        if let LOCATION_ID = LOCATION_ID_home {
            LOCATION_ID_profile = LOCATION_ID
        }
        if let ORG_ID_home = ORG_ID_home {
            ORG_ID_profile = ORG_ID_home
        }
        if let SIGNIN_TYPE = SIGNIN_TYPE_home {
            SIGNIN_TYPE_profile = SIGNIN_TYPE
        }
        if let TOKEN = TOKEN_home {
            TOKEN_profile = TOKEN
        }
        
          //baseUrl_Profile = ""
         headerViewP.setBasicHeight(height: 0)
        basicViewHeight.constant = 185
        headerViewP.plusBtb.isSelected = true
        self.getData()
        
      //  let podBundle = Bundle(for: ProfileListVC.self)
     //   let image = UIImage(named: "plus-button", in: podBundle, compatibleWith: nil)
        let image = UIImage(named: "back_arrow")
        let button1 = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(addNewClicked))
        // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addNewClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getData(){
        
       // "LOOKUP_FLAG":"X", "SYSTEM_ID":"T", "SIGNIN_TYPE":"P"
        let params:Parameters =  ["LOOKUP_FLAG": "X", "SYSTEM_ID": "T", "SIGNIN_TYPE": "P"]
        
        let postParamHeaders = [String: String]()
        
        ServerCommunication.getDataWithGetWithDataResponse(url: "hrProfileLookups", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    
                    let serviceResponse = try decoder.decode(ProfileDashData.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if var types = serviceResponse.data?.LOOKUPS_TYPES {
                          // types.remove(at: 0)
                            self.LookUpsTypeArr = types
                            
                        }
                        if let userInfo = serviceResponse.data?.USER_INFO {
                            basicInfoG = userInfo
                            self.headerViewP.basicInfo = userInfo
                            self.headerViewP.setValues(userData: userInfo)
                            
                        }
                        
                        
                        self.profileCollectioView.reloadData()
                        
                    }
                    else {
                        
                        
                        if let dictFailure = successResponseData.result.value as? [String: AnyObject]{
                            
                            if let msg = dictFailure["message"] as? String
                            {
                                
                                DataUtil.alertMessage(msg , viewController: self)
                            }
                        }
                    }
                    // self.crytoResponse = serviceResponse
                    // cryptoResponseG = serviceResponse
                    
                    
                    
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
    class ProfileCollecCell: UICollectionViewCell{
        @IBOutlet weak var ttlLabel:UILabel!
        @IBOutlet weak var iconeImage:UIImageView!
        
    }
extension HomeProfileVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
    
        // MARK: collectionView Delegate
        
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podBundle = Bundle(for: ProfileListVC.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        
        let obj = story.instantiateViewController(withIdentifier: "ProfileListVC") as! ProfileListVC
        
        obj.obj_lookUpType = self.LookUpsTypeArr[indexPath.row]
       // self.present(obj, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(obj, animated: true)
        
        
    }
       public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
           let cellWidth = (DataUtil.screenWidth-60)/4
            return CGSize(width: cellWidth, height: cellWidth)
            
        }
        
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
            return self.LookUpsTypeArr.count
            
        }
        
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let identifier = "ProfileCollecCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProfileCollecCell
            
            let obj = self.LookUpsTypeArr[indexPath.row]
            cell.ttlLabel.text = obj.LOOKUP_TYPE
            
            return cell
            
        }
        
        
        
    }


protocol updateProfileListData: class {
    func updateListData(attributArray: [AttributeForm],listId: String, isUpdate: Bool)
}

