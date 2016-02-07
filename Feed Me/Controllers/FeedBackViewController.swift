//
//  FeedBackViewController.swift
//  Swagat_MyGola
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit
import Photos
import MapKit

var indexVal : Int!

class FeedBackViewController: UIViewController,UIImagePickerControllerDelegate, AnnotationControllerDelegate, UICollectionViewDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate,AnnotationCollectionViewCellDelegate {
  
  @IBOutlet weak var photoCollectionView: UICollectionView!
  @IBOutlet weak var viewCollection: UIView!
  @IBOutlet weak var addButton: UIButton!

  @IBOutlet var btnStars: [UIButton]!
  
  var indexValuePath : NSIndexPath!
  var viewAnnotation : UIView!
  var photoImageView: UIImageView?
  var imageArray :NSMutableArray = []
  var captionArray : NSMutableArray = []
  var imageSection = 1
  var indexValue : Int = Int()
  var longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer()
  var collectionCount: Int = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for i in 0...btnStars.count-1
    {
      btnStars[i].setBackgroundImage(UIImage(named: "seat-disabled"), forState: UIControlState.Normal)
    }
    
    longPress = UILongPressGestureRecognizer(target: self, action: "longPressDetected:")
    longPress.minimumPressDuration = 0.5
    longPress.delaysTouchesBegan = true
    longPress.delegate = self
    longPress.cancelsTouchesInView = false
    
    var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapAction:")
    tapGesture.numberOfTapsRequired = 2
    self.view.addGestureRecognizer(tapGesture)
    
    photoCollectionView.showsHorizontalScrollIndicator = false
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "backGround:",name:"back", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopWiggling:",name:"stop", object: nil)
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Add Photo Button
  @IBAction func plusButtonAction(sender: AnyObject) {
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    let sourceView = UIView()
    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    imagePicker.delegate = self
    
    
    sheet.addAction(UIAlertAction(title: NSLocalizedString("Take New Photo",comment:"Take new photo"), style:
      UIAlertActionStyle.Default, handler: { (action) -> Void in
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.cameraCaptureMode = .Photo
        imagePicker.cameraDevice =  UIImagePickerControllerCameraDevice.Rear
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }))
    sheet.addAction(UIAlertAction(title: NSLocalizedString("Choose Existing",comment:"Choose existing"), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
      imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      imagePicker.modalPresentationStyle = UIModalPresentationStyle.Popover;
      imagePicker.popoverPresentationController?.sourceView = self.addButton
      imagePicker.popoverPresentationController?.sourceRect = self.addButton.bounds
      imagePicker.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Unknown
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }))
    
    sheet.popoverPresentationController?.sourceView = addButton
    sheet.popoverPresentationController?.sourceRect = addButton.bounds
    
    sheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Unknown
    sheet.preferredContentSize = CGSize(width: 200, height: 100)
    self.presentViewController(sheet, animated: true, completion: nil)
    
  }
  
  
  //MARK: - Image Annotation Controller
  
  func ProgressNoteCancelButtonClicked() {
    if viewAnnotation != nil {
      viewAnnotation?.removeFromSuperview()
      viewAnnotation = nil
    }
  }
  
  func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
    if viewAnnotation != nil {
      viewAnnotation = nil
    }
  }
  
  func cancelButtonClicked() {
    if viewAnnotation != nil {
      viewAnnotation?.removeFromSuperview()
      viewAnnotation = nil
    }
  }
  
  func saveButtonClicked(newImage: UIImage, newCaption : String) {
    if viewAnnotation != nil {
      viewAnnotation?.removeFromSuperview()
      viewAnnotation = nil
    }
    
    if photoImageView!.image != nil {
      photoImageView!.image = newImage
      imageArray[indexValue]  = newImage as UIImage
      captionArray[indexValue] = newCaption as String
      indexVal = indexValue
      createAlbumAndSaveImage((photoImageView!.image)!)
    }
    photoCollectionView.reloadData()
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  var mode:Int = 0 {
    didSet {
      self.onModeSet(self.mode)
    }
  }
  
  private func onModeSet(mode:Int) {
    var i = 0
    
    let cells:[AnyObject] = photoCollectionView.visibleCells() as! [AnnotationCollectionViewCell]
    if cells.count > 0 {
      for i in 0...cells.count-1 {
        if cells[i].isKindOfClass(AnnotationCollectionViewCell) {
          (cells[i] as! AnnotationCollectionViewCell).mode = mode
        }
      }
    }
  }
  
  // long press func for images
  func longPressDetected(gestureRecognizer: UILongPressGestureRecognizer) {
    
    if (collectionCount > 0) {
      if (gestureRecognizer.state != UIGestureRecognizerState.Began) {
        return
      }
      addButton.userInteractionEnabled = false
      let p: CGPoint = gestureRecognizer.locationInView(photoCollectionView)
      //            let indexPath: NSIndexPath = photoCollectionView.indexPathForItemAtPoint(p)!
      
      if let indexPath:NSIndexPath = photoCollectionView.indexPathForItemAtPoint(p) {
        indexValuePath = indexPath
        
        let cell: AnnotationCollectionViewCell = photoCollectionView.cellForItemAtIndexPath(indexPath)! as! AnnotationCollectionViewCell
        var val = indexPath.item
        
        //                if indexPath != nil {
        self.mode = 1
        //                }
      }
      
    }
    
  }
  
  //UITapGestureRecognizer Action
  func tapAction(sender : AnyObject) {
    addButton.userInteractionEnabled = true
    NSNotificationCenter.defaultCenter().postNotificationName("stop", object: nil)
  }
  
  func annotationCollectionViewCellOnRemove(indexPos: NSIndexPath) {
    self.removePhoto(indexPos)
  }
  
  private func removePhoto(indexPos:NSIndexPath) {
    self.imageArray.removeObjectAtIndex(indexPos.item)
    self.captionArray.removeObjectAtIndex(indexPos.item)
    
    collectionCount--
    //        self.mode = 0
    photoCollectionView.reloadData()
    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
  }
  
  func backGround(notification: NSNotification){
    //load data here
    if mode == 1 {
      mode = 1
    }
  }
  
  func stopWiggling(notification: NSNotification) {
    self.mode = 0
    
  }
  
  //MARK: - Image Picker Method
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    // If its from the photo library, don't save it. If it's from the camera, save it to an album named after the app
    if info[UIImagePickerControllerReferenceURL] == nil {
      createAlbumAndSaveImage(image)
    }
    
    var tempImage:UIImage?
    
    photoImageView = UIImageView(image: image)
    imageAnnotation.image = photoImageView?.image
    tempImage = photoImageView?.image!
    imageArray[collectionCount] = tempImage!
    captionArray[collectionCount] = ""
    collectionCount++
    photoCollectionView.hidden = false
    photoCollectionView.reloadData()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func createAlbumAndSaveImage(image : UIImage) {
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult!
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", "MyGola")
    let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
    
    if let first_obj: AnyObject = collection.firstObject {
      assetCollection = collection.firstObject as! PHAssetCollection
      
      PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
        let assetPlaceholder = assetRequest.placeholderForCreatedAsset
        let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection, assets: photosAsset)
        albumChangeRequest.addAssets([assetPlaceholder])
        }, completionHandler: nil)
      
    } else {
      PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        var createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle("Passenger +")
        assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
          if (success) {
            var collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([assetCollectionPlaceholder.localIdentifier], options: nil)
            assetCollection = collectionFetchResult?.firstObject as! PHAssetCollection
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
              let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
              let assetPlaceholder = assetRequest.placeholderForCreatedAsset
              let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection, assets: photosAsset)
              albumChangeRequest.addAssets([assetPlaceholder])
              }, completionHandler: nil)
          }
      })
    }
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - Collection View
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionCount == 0 {
      return 1
    }
    return collectionCount
  }
  
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell : AnnotationCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! AnnotationCollectionViewCell
    cell.backgroundColor = UIColor.whiteColor()
    cell.indexValue = indexPath
    cell.delegate = self
    cell.addGestureRecognizer(longPress)
    longPress = UILongPressGestureRecognizer(target: self, action: "longPressDetected:")
    
    if collectionCount == 0 {
      cell.imgAnnoted.image = UIImage(named: "annotationPhoto.png")
      self.mode = 0
    }
    else {
      cell.imgAnnoted.image = imageArray[indexPath.row] as? UIImage
    }
    return cell
    
  }
  
  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    var c = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! AnnotationCollectionViewCell
    c.layer.cornerRadius = 5.0
    c.delegate = self
    c.indexValue = indexPath
    if cell.isKindOfClass(AnnotationCollectionViewCell) {
      (cell as! AnnotationCollectionViewCell).mode = mode
    }
  }
  
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if self.mode == 0 {
      if photoImageView != nil {
        
        let viewBindings = ["photoImageView": imageArray[indexPath.row]]
        if viewAnnotation != nil {
          viewAnnotation?.removeFromSuperview()
          viewAnnotation = nil
        }
        
        //annotationVC
        var annotationVC : AnnotationController? = AnnotationController(nibName: "AnnotationController", bundle: NSBundle.mainBundle()) as AnnotationController
        annotationVC!.callBack = self
        
        annotationVC?.selectedImage!.image = imageArray[indexPath.row] as? UIImage
        annotationVC?.txtAnnotationDetails.text = captionArray[indexPath.row] as? String
        indexValue = indexPath.row
        indexValuePath = indexPath
        annotationVC!.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        annotationVC!.preferredContentSize = CGSize(width: 550, height: 600)
        self.presentViewController(annotationVC!, animated: true, completion: nil)
        
        //                self.navigationController?.pushViewController(annotationVC!, animated: false)
        
        collectionView.reloadData()
        
      }
      
      
    }
    
  }
  
  @IBAction func btnRateStarsTapped(sender: AnyObject) {
    for i in 0...btnStars.count-1
    {
      if sender.tag < i
      {
        btnStars[i].setBackgroundImage(UIImage(named: "starblank"), forState: UIControlState.Normal)
      }
      else
      {
        btnStars[i].setBackgroundImage(UIImage(named: "starfilled"), forState: UIControlState.Normal)
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in
          self.btnStars[i].transform = CGAffineTransformMakeScale(1.1, 1.1);
          }) { (finished) -> Void in
            UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
              self.btnStars[i].transform = CGAffineTransformMakeScale(1.0, 1.0);
              }, completion: nil)
        }

      }
    }
  }
  

  
}

