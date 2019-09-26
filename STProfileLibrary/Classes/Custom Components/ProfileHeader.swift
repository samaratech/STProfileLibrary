//
//  ProfileHeader.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/22/19.
//  Copyright © 2019 learning. All rights reserved.
// https://stackoverflow.com/questions/28501010/add-a-custom-color-palette-to-xcode-interface-builder

import UIKit
import Alamofire
  public class ProfileHeader: UIView {
    var vc: UIViewController!
     let picker = UIImagePickerController()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblTemType: UILabel!
    @IBOutlet weak var lblEmpId: UILabel!
    @IBOutlet weak var lblDoj: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmergencyCont: UILabel!
    
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var plusBtb: UIButton!
    @IBOutlet weak var basicViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var  profImgview: UIImageView!
    public var basicInfo:UserBasicInfo?
    var profileImage: UIImage?
  @IBOutlet fileprivate var mView: UIView!
   fileprivate var view:UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    func loadView() {
    
        let podBundle = Bundle(for: ProfileHeader.self)
        let nib = UINib(nibName: "ProfileHeader", bundle: podBundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        mView.backgroundColor = cellColor
        if let userD = basicInfoG {
            self.basicInfo = userD
            self.setValues(userData: userD)
        }
        
        profImgview.layer.borderWidth = 1.0
        profImgview.layer.masksToBounds = false
        //        profImgview.layer.borderColor = .gra
        profImgview.layer.cornerRadius = profImgview.frame.size.width / 2
        profImgview.clipsToBounds = true
        let image1 = UIImage(named: "acount_down_arrow")
        let image2 = UIImage(named: "acount_up_arrow")
 
        self.plusBtb.setImage(image1, for: .selected)
        self.plusBtb.setImage(image2, for: .normal)
        self.plusBtb.setImage(image2, for: .highlighted)
        
        
      //  let imageEdit = UIImage(named: "edit.png")
         let imageEdit = UIImage(named: "edit.png")?.withRenderingMode(.alwaysOriginal)
        self.editBtn.setBackgroundImage(imageEdit, for: .normal)
        self.editBtn.setBackgroundImage(imageEdit, for: .normal)
        self.editBtn.setBackgroundImage(imageEdit, for: .highlighted)
    }
    
    public func setBasicHeight(height:CGFloat){
        if height < 1 {
            basicInfoView.isHidden = true
        }
        else {
            basicInfoView.isHidden = false
        }
         basicViewHeight.constant = height
        
    }
    public func setValues(userData: UserBasicInfo) {
         DispatchQueue.main.async {
        if let fname = userData.FNAME, let mname = userData.MNAME, let lname = userData.LNAME {
           self.lblName.text = DataUtil.getFullName(firstname: fname, middlename: mname, lastname: lname)
        }
        
        if let email = userData.EMAIL {
            self.lblEmail.text = email
        }
        if let empId = userData.EMPLOYEE_NUMBER {
            self.lblEmpId.text = empId
        }
        if let dob = userData.DOB {
            self.lblDob.text = dob
        }
        if let mobile = userData.MOBILE_NO {
            self.lblMobile.text = mobile
        }
        if let dob = userData.DATE_OF_JOIN {
            self.lblDoj.text = dob
        }
        if let dob = userData.TEAM_NAME {
            self.lblTemType.text = dob
        }
        if let dob = userData.USER_TYPE {
            self.lblDesignation.text = dob
        }
        if let gender = userData.GENDER {
            self.lblGender.text = gender
        }
        if let imgUrl = userData.PROFILE_IMAGE {
            guard let url = URL(string: imgUrl) else { return  }
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.profImgview.image = image
            }
            
        }
        var arrAddress = [String]()
        if (userData.ADDRESS1 ?? "").count > 0 {
            arrAddress.append(userData.ADDRESS1 ?? "")
        }
        if (userData.ADDRESS2 ?? "").count > 0 {
            arrAddress.append(userData.ADDRESS2 ?? "")
        }
        if (userData.ADDRESS3 ?? "").count > 0 {
            arrAddress.append(userData.ADDRESS3 ?? "")
        }
        if (userData.CITY ?? "").count > 0 {
            arrAddress.append(userData.CITY ?? "")
        }
        if (userData.STATE_CODE ?? "").count > 0 {
            arrAddress.append(userData.STATE_CODE ?? "")
        }
        if (userData.COUNTRY_CODE ?? "").count > 0 {
            arrAddress.append(userData.COUNTRY_CODE ?? "")
        }
        if (userData.POSTAL_CODE ?? "").count > 0 {
            arrAddress.append(userData.POSTAL_CODE ?? "")
        }
        let fullAdd = arrAddress.joined(separator: ",")
        self.lblAddress.text = fullAdd
        }
    }
    @IBAction func openDocumentPicker(_ sender: Any) {
        
  
        let actionsheet = UIAlertController(title: "", message: "Select profile Image", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        actionsheet.addAction(UIAlertAction.init(title: "From Library", style: .default, handler: { (action) in
            self.selectFromLibrary()
        }))
        actionsheet.addAction(UIAlertAction.init(title: "From Camera", style: .default, handler: { (action) in
            self.selectFromCamera()
        }))
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = actionsheet.popoverPresentationController {
                popoverController.sourceView = self.vc.view
                popoverController.sourceRect = CGRect(x: self.vc.view.bounds.midX, y: self.vc.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        
        vc.present(actionsheet, animated: true, completion: nil)
        
    }
    func selectFromLibrary() {
    
         picker.allowsEditing = false
         picker.delegate = self
         picker.sourceType = .photoLibrary
         picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
         vc.present(picker, animated: true, completion: nil)
    }
    func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            vc.present(picker,animated: true,completion: nil)
        } else {
            DataUtil.alertMessage("Sorry, this device has no camera", viewController: vc)
        }
    }
    func uploadProfileImage(image: UIImage) {
         var params = Parameters()
        params["USERNAME"] = "tess"//"tess"
        let imgData = image.jpegData(compressionQuality: 0.6)
        ServerCommunication.postProfilePictureHandler(url: "upload_profile_image", postParam: params, imgData: imgData!, viewController: vc, success: { (successResponseData) in
            self.profImgview.image = image
          //  self.vc.dismiss(animated: true, completion: nil)
            
        }) { (dic) in
            
        }
        
    }
}//(successResponseData) in(successResponseData) in
extension ProfileHeader : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: - Delegates
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[.originalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    
        let resizedImage = self.resizeImage(image: chosenImage, targetSize: CGSize(width: 200.0, height: 200.0))
      //  self.ivProfile.image = resizedImage
        self.uploadProfileImage(image: resizedImage)

       picker.dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /*
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            
    }
    */
}




