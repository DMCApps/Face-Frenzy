import UIKit
import FaceTracker

class FaceTrackerView: UIViewController, FaceTrackerViewOps, FaceTrackerViewControllerDelegate, ActionsDelegate {
    
    // MARK: Properties
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var faceTrackerContainerView: UIView!
    @IBOutlet weak var ibActionMenuTopToContainerConstraint: NSLayoutConstraint!
    
    var faceTrackerViewController: FaceTrackerViewController?
    var actionsView: ActionsView?
    
    var hatView = UIImageView()
    var pointViews = [UIView]()
    
    var startTranslationConstraintConstant:CGFloat?
    
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
        if segue.identifier == "embedFaceTrackerViewController" {
            faceTrackerViewController = segue.destination as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
        else if segue.identifier == "embedActionsViewController" {
            actionsView = segue.destination as? ActionsView
            // TODO: with MVP should the view or the presenter be the delegate?
            actionsView!.delegate = self
        }
    }
    
    // MARK: Accessors
    
    // MARK: Actions
    
    // MARK: Public
    
    // MARK: Private
    
    func animateActionMenuTo(_ value:CGFloat, withDuration duration:TimeInterval = 0.33) {
        self.ibActionMenuTopToContainerConstraint.constant = value
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: <NameOfProtocol>
    
    // MARK: <ActionsDelegate>
    
    func openActionsMenu() {
        animateActionMenuTo(190)
    }
    
    func closeActionsMenu() {
        animateActionMenuTo(30)
    }
    
    func showFacePoints() {
        for pointView in pointViews {
            pointView.isHidden = false
        }
    }
    
    func didBeginTranslation() {
        // TODO: Should the model and presenter handle these things?
        self.startTranslationConstraintConstant = self.ibActionMenuTopToContainerConstraint.constant
    }
    
    func didTranslateBy(_ translation: CGFloat) {
        // TODO: Should the model and presenter handle these things?
        guard let startTranslationConstraintConstant = self.startTranslationConstraintConstant else {
            return
        }
        
        var newConstraintConstant = startTranslationConstraintConstant + translation
        newConstraintConstant = newConstraintConstant.clamp(to: (30 ... 190))
        animateActionMenuTo(newConstraintConstant, withDuration: 0.05)
    }
    
    func didEndTranslation() {
        // TODO: Should the model and presenter handle these things?
        // TODO: Complete open or close operation
        
        self.startTranslationConstraintConstant = nil
    }
    
    // MARK: <FaceTrackerViewControllerDelegate>
    
    func faceTrackerDidUpdate(_ points: FacePoints?) {
        self.presenter.didReceiveFacePoints(points)
    }
    
    // MARK: <FaceTrackerViewOps>
    
    func positionFacePoints(_ points:FacePoints) {
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
            
            pointView.frame = CGRect(x: point.x - pointSize / 2,
                                     y: point.y - pointSize / 2,
                                     width: pointSize,
                                     height: pointSize).integral
        })
    }
    
    func repositionHatView(usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        let hatWidth = 2.0 * faceAnalyzer.outterEyeDistance()
        let hatHeight = (hatView.image!.size.height / hatView.image!.size.width) * hatWidth
        
        hatView.transform = CGAffineTransform.identity
        
        let eyeToEyeCenter = faceAnalyzer.eyeToEyeCenter()
        hatView.frame = CGRect(x: eyeToEyeCenter.x - hatWidth / 2,
                               y: eyeToEyeCenter.y - 1.3 * hatHeight,
                               width: hatWidth,
                               height: hatHeight)
        
        hatView.isHidden = false
        
        hatView.anchorTo(point: CGPoint(x: 0.5, y: 1.0))
        
        let angle = faceAnalyzer.leftToRightEyeAngle()
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
