//

//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController,iCarouselDataSource, iCarouselDelegate,UIPickerViewDataSource,UIPickerViewDelegate
 {
  
  
  
  

    // not Needed
    var items: [Int] = []
    
    // Just add the images and put the image name in this array ur carousel is ready for you :) Insert the Image names Here
  var pageImages: NSMutableArray = NSMutableArray()
  var arrairlinesName : NSMutableArray = NSMutableArray()
  var arrayDep: NSMutableArray = NSMutableArray()
  var arrayArr : NSMutableArray = NSMutableArray()
  var arrPrice: NSMutableArray = NSMutableArray()
  var arrCode: NSMutableArray = NSMutableArray()
  var arrTime: NSMutableArray = NSMutableArray()
    //Mark - iCarousel
    
  @IBOutlet weak var lblFareEstimate: UILabel!
  @IBOutlet weak var lblCode: UILabel!
  @IBOutlet weak var lblArrivalTime: UILabel!
  @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet var carousel : iCarousel!
  @IBOutlet weak var lblDeparturePlace: UILabel!
  @IBOutlet weak var lblArrivalPlacePlace: UILabel!

    var reflectionView: ReflectionView!
    
    var alertVc: UIAlertController!
    
    var carouselSize: CGFloat! = 2.0
    
    var carouselBorderWidth: CGFloat! = 0.5
    
    
    
    var imageView: UIImageView!
    
    
    
    
    //Mark - PickerView
    
    
    //Picker Values in array - data - For Row1 and Row2
    
    //Values - Row1
    let carouselType = ["Linear", "Rotary", "InvertedRotary", "Cylinder", "InvertedCylinder", "Wheel", "InvertedWheel", "CoverFlow", "CoverFlow2", "TimeMachine","InvertedTimeMachine"]
    
    //Values - Row2
    let shape = ["Horizontal","Vertical"]
    
    let size = ["0","20","50","70","100","200"]
    
  
  func parseJSON(){
    var path = NSBundle.mainBundle().pathForResource("flightSearches", ofType: "json")
    var data = NSData(contentsOfFile: path!)
    var json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
    
    var dataField:NSDictionary = json.valueForKey("data") as! NSDictionary
    var onwardFlights:NSArray = dataField.valueForKey("onwardflights") as! NSArray
    
    print(onwardFlights)
    
    for values in onwardFlights{
      
      if(values.valueForKey("ArrivalTime") != nil){
        var arrivalTime: String = values.valueForKey("ArrivalTime") as! String
        arrTime.addObject(arrivalTime)

      } else {
        var  arrivalTime = "NA"
        arrTime.addObject(arrivalTime)

      }
      
      if(values.valueForKey("origin") != nil){
        var origin: String = values.valueForKey("origin") as! String
        arrayArr.addObject(origin)
        arrayArr.addObject(origin)

      }else{
        var origin = "NA"
        arrayArr.addObject(origin)

      }
      if(values.valueForKey("destination") != nil){
        var dest:String = values.valueForKey("destination") as! String
        arrayDep.addObject(description)
      }else{
        var dest = "NA"
        arrayDep.addObject(description)

      }
      var priceSolution:NSDictionary?
      if(values.valueForKey("PricingSolution") != nil){
        
        priceSolution = values.valueForKey("PricingSolution") as? NSDictionary
      }else{
        priceSolution = NSDictionary()
      }
      
      if(priceSolution!.valueForKey("TotalPrice") != nil){
        var price = priceSolution!.valueForKey("TotalPrice") as! String
        arrPrice.addObject(arrPrice)
      }else{
        var price = "NA"
        arrPrice.addObject(arrPrice)

      }
      
      if(values.valueForKey("TotalPrice") != nil){
        var CabinClass = values.valueForKey("CabinClass") as! String
        
      }else{
        var CabinClass = "NA"
        
      }
      if(values.valueForKey("TotalPrice") != nil){
        var airline  = values.valueForKey("airline") as! String
        arrairlinesName.addObject(airline)
        
      }else{
        var airline = "NA"
        arrairlinesName.addObject(airline)
      }
      if(values.valueForKey("TotalPrice") != nil){
        var  flightcode = values.valueForKey("flightcode") as! String
        arrCode.addObject(flightcode)
      }else{
        var  flightcode = "NA"
        arrCode.addObject(flightcode)

      }
      
      
      self.carousel.reloadData()
      
      
    }
    
  }
  
  
    //Picker View Outlets
    @IBOutlet weak var pickerView: UIPickerView!
  
    @IBOutlet weak var pickerSwitch: UISwitch!
  
    @IBAction func pickerSwitchAction(sender: AnyObject) {
      
        if pickerSwitch.on{
          
            pickerView.hidden = false
          
            showCloseBtn.hidden = false
          
        } else{
          
            pickerView.hidden = true
          
            showCloseBtn.hidden = true
          
        }
      
    }
  
  
    //Mark - Tool Bar bottom View
  
    @IBOutlet weak var bottomTBar: UIToolbar!
  
    @IBOutlet weak var showCloseBtn: UISegmentedControl!
  
  
    // We are not using Items array - will be usable if needed
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        parseJSON()
        //Initial Loading - Type of Carousel
      
        
    }
    
    
    //Action of Show and Close Button - not Needed now
    @IBAction func showCloseBtnAction(sender: AnyObject) {
        
        
        switch (sender.selectedSegmentIndex) {
            
        case 0:
            println("show")
            
            /* alertVc = UIAlertController(title: "sample", message: "message", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            
            alertVc.addAction(UIAlertAction(title: "sample", style: UIAlertActionStyle.Default, handler: nil))
            
            
            self.presentViewController(alertVc, animated: true, completion: nil)
            */
            
            pickerView.hidden = false
            
            showCloseBtn.hidden = false
            
            break;
            
        case 1:
            println("Close")
            
            pickerView.hidden = true
            
            showCloseBtn.hidden = true
            
            break;
        default:
            break;
        }
    }
    
    
    
    
    
    
    //Mark - Picker View Implementation
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        //No of PickerView Sections - we are using 2 sections
        return arrPrice.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //initalize the count
        var count: Int = 0
        
        switch (component) {
            
        case 0:
            
            count = carouselType.count
            
        case 1:
            
            count = shape.count
            
        case 2:
            
            count = size.count
            
        default:
            break;
        }
        
        return count
    }
    
    //This is not needed as we are using attributed string method - as we are customising the text in the pickerview to white color
    
    /* func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    
    
    
    var title: String = ""
    
    
    switch (component) {
    case 0:
    
    title = carouselType[row]
    
    
    case 1:
    title = "\(shape[row])"
    
    
    default:
    break;
    }
    
    return title
    }
    
    */
    
    
    // Changing the text in the label when chaging the values in the picker view
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //START - of Component Row Switch Case
        
        
        
        switch (component) {
            
        case 0:
            
            // let carouselType = ["Linear", "Rotary", "InvertedRotary", "Cylinder", "InvertedCylinder", "Wheel", "InvertedWheel", "CoverFlow", "CoverFlow2", "TimeMachine", "InvertedTimeMachine"]
            
            
            // START - of Switch case for Row 1 - change Carousel type
            
            switch (carouselType[row]) {
                
            case "Linear":
                
                carousel.type  = .Linear
                
                
                break;
                
            case "Rotary":
                
                
                carousel.type  = .Rotary
                
                break;
                
            case "InvertedRotary":
                
                carousel.type  = .InvertedRotary
                
                break;
                
                
                
            case "Cylinder":
                
                carousel.type  = .Cylinder
                
                break;
                
            case "InvertedCylinder":
                
                carousel.type  = .InvertedCylinder
                
                break;
                
            case "Wheel":
                
                carousel.type  = .Wheel
                
                break;
                
            case "InvertedWheel":
                
                carousel.type  = .InvertedWheel
                
                break;
                
            case "CoverFlow":
                
                carousel.type  = .CoverFlow
                
                break;
                
            case "CoverFlow2":
                
                carousel.type  = .CoverFlow2
                
                break;
                
            case "TimeMachine":
                
                carousel.type  = .TimeMachine
                
                break;
                
            case "InvertedTimeMachine":
                
                carousel.type  = .InvertedTimeMachine
                
                break;
                
                
            default:
                break;
                
            }
            
            
            showCloseBtn.setTitle(carouselType[row], forSegmentAtIndex: 0)
            
            
            break;
            //END of change Carousel Type  Switch Case
            
        case 1:
            
            // START - Switch case for Row 2 - change Carousel Direction
            
            switch (shape[row]) {
                
            case "Vertical":
                
                carousel.vertical = true
                
                
                break;
                
            case "Horizontal":
                
                carousel.vertical = false
                
                break;
                
            default:
                break;
            }
            
            showCloseBtn.setTitle(shape[row], forSegmentAtIndex: 1)
            
            break;
            
        case 2:
            
            
            
            switch (size[row]) {
                
                
                
            case "0":
                
                carouselSize = 0.0
                
                
                carouselBorderWidth = 0.5
                
                
                break;
                
            case "20":
                
                carouselSize = 20.0
                
                carouselBorderWidth = 0.0
                
                
                break;
                
            case "50":
                
                
                carouselSize = 50.0
                
                carouselBorderWidth = 0.0
                
                
                break;
                
                
            case "70":
                
                carouselSize = 70.0
                
                carouselBorderWidth = 0.0
                
                
                
                break;
                
            case "100":
                
                carouselSize = 100.0
                
                carouselBorderWidth = 0.0
                
                
                
                break;
                
            case "150":
                
                carouselSize = 150.0
                
                carouselBorderWidth = 0.0
                
                
                
                break;
                
            case "200":
                
                carouselSize = 200.0
                
                carouselBorderWidth = 0.0
                
                
                
                break;
                
                
            default:
                
                break;
                
            }
            
            
            break
            //END of change Carousel Size Switch Case
            
        default:
            
            break;
            
        }
        
        
        //END of Component Row Switch Case
        
        carousel.reloadData()
        
    }
    
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        //intitalize the return String
        var title: String = ""
        
        //START - of Picker Text Color change - switch case
        switch (component) {
            
        case 0:
            
            title = carouselType[row]
            
            
        case 1:
            
            title = "\(shape[row])"
            
            
            
        case 2:
            
            title = "\(size[row])"
            
            
        default:
            
            break;
            
        }
        
        //End - of Picker Text Color change - switch case
        
        
        // Returning the text with the attributed color for Picker view
        
        let attributedString = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
        
        return attributedString
        
        
    }
    
    
    //MARK - iCarousel - no of Items
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        
        return arrPrice.count
        
    }
  
    
    /*     func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView) -> UIView!
    {
    var label: UILabel! = nil
    
    
    //BOOL test = [self isKindOfClass:[SomeClass class]];
    
    
    var newView = view
    
    //create new view if no view is available for recycling
    if (newView == nil)
    {
    //don't do anything specific to the index within
    //this `if (view == nil) {...}` statement because the view will be
    //recycled and used with other index values later
    view = UIImageView(frame:CGRectMake(0, 0, 200, 200))
    (view as! UIImageView!).image = UIImage(named: "page.png")
    view.contentMode = .Center
    
    label = UILabel(frame:view.bounds)
    label.backgroundColor = UIColor.clearColor()
    label.textAlignment = .Center
    label.font = label.font.fontWithSize(50)
    label.tag = 1
    view.addSubview(label)
    }
    else
    {
    //get a reference to the label in the recycled view
    label = view.viewWithTag(1) as! UILabel!
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = "\(items[index])"
    
    return newView
    }
    */
    
    
    
    //Customising the Carouselview
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: ReflectionView!) -> UIView {
        
        var label: UILabel! = nil
        
        var newView = view
      if let place = arrayArr[index] as? String
      {
        lblArrivalPlacePlace.text = "\(arrayArr[index])"
      }
      if let place: AnyObject = arrPrice[index] as? String
      {
        lblFareEstimate.text = "\(arrPrice[index])"
      }
      if let place: AnyObject = arrayArr[index] as? String
      {
        lblArrivalTime.text = "\(arrTime[index])"
      }
      if let place: AnyObject = arrayArr[index] as? String
      {
        lblFlightName.text = "\(arrairlinesName[index])"
      }
      if let place: AnyObject = arrayArr[index] as? String
      {
        lblDeparturePlace.text = "\(arrayDep[index])"
      }
      if let place: AnyObject = arrayArr[index] as? String
      {
        lblFlightName.text = "\(arrairlinesName[index])"
      }
      if let place: AnyObject = arrayArr[index] as? String
      {
        lblCode.text = "\(arrCode[index])"
      }
    
        var itemWidth:CGFloat! = 0.0
        var itemHeight:CGFloat! = 0.0
        
        
        //create new view if no view is available for recycling
        if (newView == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            
            // Invoking the reflection View and Change the size of View according to device width and height - This code enable the reSizing for both iPhone and iPad
            
            
            
            
            
            switch (UIDevice.currentDevice().userInterfaceIdiom) {
                
            case .Phone:
                
                
                switch (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
                    
                case true:
                    
                    itemWidth =  self.view.frame.width/2.84
                    
//                    itemHeight =  self.view.frame.height/1.5
                    
                    
                    itemWidth =  itemHeight
                    
                    
                    println(" iPhone LandsCape : Item Width: \(itemWidth) Item Height: \(itemHeight) : Screen Width: \(self.view.frame.width) : Screen Height: \(self.view.frame.height)")
                    
                    break;
                    
                case false:
                    
                  itemWidth =  self.view.frame.width/2.0
                  
                    itemHeight = itemWidth
                    
                    println(" iPhone Portait : Item Width: \(itemWidth) Item Height: \(itemHeight) : Screen Width: \(self.view.frame.width) : Screen Height: \(self.view.frame.height)")
                    
                    
                    break;
                    
                default:
                    
                    break;
                    
                }
                
                
                
                
                break;
                
            case .Pad:
                
                switch (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
                    
                case true:
                    
                    itemHeight =  self.view.frame.height/2
                    
                    
                    itemWidth =  itemHeight
                    
                    println(" iPad LandsCape : Item Width: \(itemWidth) Item Height: \(itemHeight) : Screen Width: \(self.view.frame.width) : Screen Height: \(self.view.frame.height)")
                    
                    break;
                    
                case false:
                    
                    itemWidth =  self.view.frame.width/2
                    
                    itemHeight = itemWidth
                    
                    println(" iPad Portait : Item Width: \(itemWidth) Item Height: \(itemHeight) : Screen Width: \(self.view.frame.width) : Screen Height: \(self.view.frame.height)")
                    
                    
                    break;
                    
                default:
                    
                    break;
                    
                }
                
                
                
                
                break
            default:
                break;
            }
            
            
            
            
            newView = ReflectionView(frame:CGRectMake(0, 0, itemWidth, itemHeight))
          
            
            
            
            newView.layer.borderWidth = carouselBorderWidth
            
            
            
            
            newView.layer.borderColor = UIColor.whiteColor().CGColor
            
            //newView.layer.masksToBounds = true
            
            //newView.backgroundColor = UIColor.redColor()
            
            imageView = UIImageView(frame: newView.bounds)
            
//            imageView.image = UIImage(named: pageImages[index] as! String)
          
            imageView.layer.cornerRadius = carouselSize
            
            imageView.layer.masksToBounds = true
            
            
            
            /*Change content mode to fit the Image*/
//            imageView.contentMode = .ScaleToFill
          
//            newView.addSubview(imageView)
          
            //(newView as! ReflectionView!).image = UIImage(named: "page.png")
            newView.contentMode = .Center
            
            
            // Not used as far of now - will be sued if u want to display bale in carousel
            label = UILabel(frame:newView.bounds)
            
            label.backgroundColor = UIColor.clearColor()
            
            label.textAlignment = .Center
            
            label.font = label.font.fontWithSize(50)
            
            label.tag = 1
            
            newView.addSubview(label)
            
        } else {
            
            //get a reference to the label in the recycled view
            label = newView.viewWithTag(1) as! UILabel!
        }
        
        
        // Retun the reflection View
        return newView
        
    }
    
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
        
    {
        
        if (option == .Spacing)
        {
            
            return value * 1.1
            
        }
        
        return value
    }
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        carousel.reloadData()
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        println(index)
    }
  @IBAction func btnTryOlatapped(sender: AnyObject) {
    var stry = UIStoryboard(name: "Main", bundle: nil)
    var cabHistoryViewController : CabDetailsViewController = stry.instantiateViewControllerWithIdentifier("CabDetailsViewController") as! CabDetailsViewController
    self.navigationController?.pushViewController(cabHistoryViewController, animated: false)
    

  }
  
}

