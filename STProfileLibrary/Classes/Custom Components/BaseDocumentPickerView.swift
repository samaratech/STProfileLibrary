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
protocol BaseDocPickerDelegate: class {
    
    func UpdateDocPickerImage(view: BaseDocumentPickerView,index: Int,image: [UIImage])
    
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
        
        let image1 = UIImage(named: "attachment")
        self.attachBtn.setImage(image1, for: .selected)
        self.attachBtn.setImage(image1, for: .normal)
        self.attachBtn.setImage(image1, for: .highlighted)
        collectioView_image.register(UINib(nibName: "collecImageCell", bundle: podBundle), forCellWithReuseIdentifier: "collecImageCell")
    }
    

    @IBAction func openDocumentPicker(_ sender: Any) {
       
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
}

extension BaseDocumentPickerView : UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
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
        var imgArr = [UIImage]()
        for img in self.imageArr {
            if img is UIImage {
                imgArr.append(img as! UIImage)
            }
        }
        self.Delegate.UpdateDocPickerImage(view: self, index: 0, image: imgArr)
        picker.dismiss(animated:true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
        
        cell.crossBtn.addTarget(self, action: #selector(crossBtnClicked(btn:)), for: .touchUpInside)
        cell.crossBtn.tag = indexPath.row
        return cell
        
    }
    @objc func crossBtnClicked(btn: UIButton) {
        
        self.imageArr.remove(at: btn.tag)
        self.collectioView_image.reloadData()
        
        var imgArr = [UIImage]()
        for img in self.imageArr {
            if img is UIImage {
                imgArr.append(img as! UIImage)
            }
        }
        
        
        self.Delegate.UpdateDocPickerImage(view: self, index: 0, image: imgArr)
      //  self.Delegate.removeDocPickerImage(view: self, index: btn.tag)
        if self.imageArr.count < 1 {
            self.collectioView_image.isHidden = true
            document_nameTF.text = ""
            //topSpacesubmitBtn.constant = 30
        }
        
    }
}
/*
class collecImageCell: UICollectionViewCell{
    @IBOutlet weak var crossBtn:UIButton!
    @IBOutlet weak var iconeImage:UIImageView!
    
}
*/
