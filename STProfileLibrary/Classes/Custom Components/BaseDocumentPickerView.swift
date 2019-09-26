//
//  BaseDocumentPickerView.swift
//  Profile
//
//  Created by Milan Katiyar on 24/07/19.
//  Copyright © 2019 learning. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SDWebImage
import OpalImagePicker
protocol BaseDocPickerDelegate: class {
    
    func UpdateDocPickerImage(view: BaseDocumentPickerView,index: Int,image: [Any])
    func RemoveDocPickerImage(view: BaseDocumentPickerView,index: Int,image: [Any],type: ImageValue)
    
    
}

public class BaseDocumentPickerView : UIView {
    @IBOutlet weak var collectioView_image:UICollectionView!
    var imageArr = [Any]()
   // var imageArraa = [Any]()
      weak var Delegate:BaseDocPickerDelegate!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var document_nameTF: UITextField!
    @IBOutlet weak var attachBtn: UIButton!
     @IBOutlet weak var sView: UIView!
    let picker = UIImagePickerController()
    var vc : UIViewController!
      var uploadImage: UIImage!
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    public func setController(vc : UIViewController){
        self.vc = vc
    }
    func initializeView() {
        let podBundle = Bundle(for: BaseDocumentPickerView.self)
        let nib = UINib(nibName: "BaseDocumentPickerView", bundle: podBundle)
        mainView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(mainView)
        mainView.frame = bounds
        mainView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        let image1 = UIImage(named: "acount_attachment")
        self.attachBtn.setImage(image1, for: .selected)
        self.attachBtn.setImage(image1, for: .normal)
        self.attachBtn.setImage(image1, for: .highlighted)
        collectioView_image.register(UINib(nibName: "collecImageCell", bundle: podBundle), forCellWithReuseIdentifier: "collecImageCell")
    }
    

    @IBAction func openDocumentPicker(_ sender: Any) {
        
        if self.imageArr.count > 2 {
        DataUtil.alertMessage("You can not add more than 3 images!!", viewController: vc)
        return
        }
       
        let actionsheet = UIAlertController(title: "", message: "Select a receipt", preferredStyle: .actionSheet)
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
        
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 3 - self.imageArr.count
        vc.present(imagePicker, animated: true, completion: nil)
        /*
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        vc.present(picker, animated: true, completion: nil)
        */
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
}

extension BaseDocumentPickerView : UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,OpalImagePickerControllerDelegate{
    public func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        self.collectioView_image.isHidden = false
        let imgCount = self.imageArr.count + images.count
        
        if imgCount > 3 {
             vc.presentedViewController?.dismiss(animated: true, completion: nil)
           DataUtil.alertMessage("You can not add more than 3 images!!", viewController: vc)
            return
        }
        /*
        guard let chosenImage = info[.originalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        */
        //uploadImage = chosenImage
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd_HHmmss"
        document_nameTF.text = dateformatter.string(from: Date()) + ".jpg"
        for chosenImage in images {
            self.imageArr.append(chosenImage)
        }
        
        self.collectioView_image.reloadData()
        var imgArr = [Any]()
        for img in self.imageArr {
            if img is UIImage {
                imgArr.append(img as! UIImage)
            }
            else if img is ImageValue {
                imgArr.append(img as! ImageValue)
            }
        }
        self.Delegate.UpdateDocPickerImage(view: self, index: 0, image: imgArr)
            vc.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    self.collectioView_image.isHidden = false
        guard let chosenImage = info[.originalImage] as? UIImage
            else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        uploadImage = chosenImage
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd_HHmmss"
        document_nameTF.text = dateformatter.string(from: Date()) + ".jpg"
        self.imageArr.append(chosenImage)
        self.collectioView_image.reloadData()
        var imgArr = [Any]()
        for img in self.imageArr {
            if img is UIImage {
                imgArr.append(img as! UIImage)
            }
            else if img is ImageValue {
                imgArr.append(img as! ImageValue)
            }
        }
        self.Delegate.UpdateDocPickerImage(view: self, index: 0, image: imgArr)
        picker.dismiss(animated:true, completion: nil)
    }
    
   public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (DataUtil.screenWidth-60)/4
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArr.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "collecImageCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! collecImageCell
        
        let img = self.imageArr[indexPath.row]
         if img is UIImage {
            cell.iconeImage.image = img as? UIImage
        }
         else if img is String {
            if let url = URL(string: img as! String) {
                print("url in  DocumentListView ==",url)
                cell.iconeImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: SDWebImageOptions(), completed: nil)
            }
        }
         else if img is ImageValue {
            if let url = URL(string: (img as! ImageValue).IMAGE_URL ?? "") {
                print("url in  DocumentListView ==",url)
                cell.iconeImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: SDWebImageOptions(), completed: nil)
            }
        }
        
        cell.crossBtn.addTarget(self, action: #selector(crossBtnClicked(btn:)), for: .touchUpInside)
        cell.crossBtn.tag = indexPath.row
        return cell
        
    }
    @objc func crossBtnClicked(btn: UIButton) {
        
        let objImg = self.imageArr[btn.tag]
        self.imageArr.remove(at: btn.tag)
        self.collectioView_image.reloadData()
        
        /*
        var imgArr = [UIImage]()
        for img in self.imageArr {
            if img is UIImage {
                imgArr.append(img as! UIImage)
            }
        }
        */
        
        if objImg is UIImage {
        
       self.Delegate.UpdateDocPickerImage(view: self, index: btn.tag, image: self.imageArr)
        }
        else if objImg is ImageValue {
            self.Delegate.RemoveDocPickerImage(view: self, index: btn.tag, image: self.imageArr, type: objImg as! ImageValue)
        }
        if self.imageArr.count < 1 {
            self.collectioView_image.isHidden = true
            document_nameTF.text = ""
            //topSpacesubmitBtn.constant = 30
        }
        else {
              self.collectioView_image.isHidden = false
        }
        
    }
}
/*
class collecImageCell: UICollectionViewCell{
    @IBOutlet weak var crossBtn:UIButton!
    @IBOutlet weak var iconeImage:UIImageView!
    
}
*/
