//
//  DocumentListView.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 8/28/19.
//
import Foundation
import UIKit
import SDWebImage
class DocumentListView: UIView {
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var collectioView_image:UICollectionView!
    var imageArr = [Any]()
    @IBOutlet var mainView: UIView!
     var vc : UIViewController!
    var titleDoc:String?
    /*
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    */
    public func setController(vc : UIViewController){
        self.vc = vc
    }
    func initializeView() {
        let podBundle = Bundle(for: DocumentListView.self)
        let nib = UINib(nibName: "DocumentListView", bundle: podBundle)
        mainView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(mainView)
        mainView.frame = bounds
        title_lbl.text = titleDoc ?? ""
      //  mainView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    
        collectioView_image.register(UINib(nibName: "collecImageCell", bundle: podBundle), forCellWithReuseIdentifier: "collecImageCell")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension DocumentListView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    
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
        cell.crossBtn.isHidden = true
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
           return cell
        
    }
 
}
