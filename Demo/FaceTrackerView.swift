import UIKit
import FaceTracker

class FaceTrackerView: UIViewController, FaceTrackerViewOps, FaceTrackerViewControllerDelegate {
    
    // MARK: Properties
    
    var hatView = UIImageView()
    var faceTrackerViewController: FaceTrackerViewController?
    var pointViews = [UIView]()
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var faceTrackerContainerView: UIView!
    
    private var presenter:FaceTrackerViewPresenterOps!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = FaceTrackerPresenter()
        self.presenter.viewDidLoad(withView:self)
        
        self.view.insertSubview(hatView, aboveSubview: faceTrackerContainerView)
        hatView.image = UIImage(named: "hat")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTrackerViewController!.startTracking { () -> Void in
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedFaceTrackerViewController") {
            faceTrackerViewController = segue.destination as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
    }
    
    // MARK: Accessors
    
    // MARK: Actions
    
    // MARK: Public
    
    // MARK: Private
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    // MARK: <NameOfProtocol>
    
    // MARK: <FaceTrackerViewControllerDelegate>
    
    func faceTrackerDidUpdate(_ points: FacePoints?) {
        self.presenter.didReceiveFacePoints(points)
    }
    
    // MARK: <FaceTrackerViewOps>
    
    func showFacePoints(_ points:FacePoints) {
        // Allocate some views for the points if needed
        if (pointViews.count == 0) {
            let numPoints = points.getTotalNumberOFPoints()
            for _ in 0...numPoints {
                let view = UIView()
                view.backgroundColor = UIColor.green
                self.view.addSubview(view)
                
                pointViews.append(view)
            }
        }
        
        // Set frame for each point view
        points.enumeratePoints({ (point, index) -> Void in
            let pointView = self.pointViews[index]
            let pointSize: CGFloat = 4
            
            pointView.isHidden = false
            pointView.frame = CGRect(x: point.x - pointSize / 2,
                                     y: point.y - pointSize / 2,
                                     width: pointSize,
                                     height: pointSize).integral
        })
    }
    
    func repositionHatViewForPoints(_ points:FacePoints) {
        // Compute the hat frame
        let leftEyeStart = points.leftEye[0]
        let rightEyeEnd = points.rightEye[5]
        
        let eyeCornerDist = leftEyeStart.distanceTo(point: rightEyeEnd)
        let eyeToEyeCenter = leftEyeStart.centerTo(point: rightEyeEnd)
        
        let hatWidth = 2.0 * eyeCornerDist
        let hatHeight = (hatView.image!.size.height / hatView.image!.size.width) * hatWidth
        
        hatView.transform = CGAffineTransform.identity
        
        hatView.frame = CGRect(x: eyeToEyeCenter.x - hatWidth / 2,
                               y: eyeToEyeCenter.y - 1.3 * hatHeight,
                               width: hatWidth,
                               height: hatHeight)
        
        hatView.isHidden = false
        
        hatView.anchorTo(point: CGPoint(x: 0.5, y: 1.0))
        
        let angle = rightEyeEnd.angleTo(point: leftEyeStart)
        hatView.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func hideFacePoints() {
        for view in pointViews {
            view.isHidden = true
        }
    }
    
    func hideHatView() {
        hatView.isHidden = true
    }
    
}
