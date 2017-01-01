import UIKit
import FaceTracker

class FaceTrackerView: UIViewController, FaceTrackerViewOps, FaceTrackerViewControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var faceTrackerContainerView: UIView!
    @IBOutlet weak var ibActionMenuTopToContainerConstraint: NSLayoutConstraint!
    
    var faceTrackerViewController: FaceTrackerViewController?
    var actionsView: ActionsView?
    
    var headImageView = UIImageView()
    var leftEyeImageView = UIImageView()
    var rightEyeImageView = UIImageView()
    var noseImageView = UIImageView()
    var pointViews = [UIView]()
    
    var startTranslationConstraintConstant:CGFloat?
    
    private var presenter:FaceTrackerViewPresenterOps = FaceTrackerPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad(withView:self)
        
        self.view.insertSubview(headImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(leftEyeImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(rightEyeImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(noseImageView, aboveSubview: faceTrackerContainerView)
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
            actionsView!.delegate = self.presenter
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
    
    func placeImageView(_ imageView:UIImageView, center:CGPoint, width:CGFloat, angle:CGFloat) {
        let height = (imageView.image!.size.height / imageView.image!.size.width) * width
        
        imageView.transform = CGAffineTransform.identity
        
        imageView.frame = CGRect(x: center.x - width / 2,
                                 y: center.y - height / 2,
                                 width: width,
                                 height: height)
        
        imageView.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    // MARK: <NameOfProtocol>
    
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
    
    func showHeadView() {
        headImageView.isHidden = false
    }
    
    func hideHeadView() {
        headImageView.isHidden = true
    }
    
    func showHeadViewWithFaceItem(_ faceItem: FaceItem) {
        headImageView.image = UIImage(named: faceItem.imageName)
        headImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        if faceAnalyzer.isReady(),
            !headImageView.isHidden,
            let image = headImageView.image {
            
            let hatWidth = 2.0 * faceAnalyzer.outterEyeDistance()
            let hatHeight = (image.size.height / image.size.width) * hatWidth
            
            headImageView.transform = CGAffineTransform.identity
            
            let eyeToEyeCenter = faceAnalyzer.eyeToEyeCenter()
            headImageView.frame = CGRect(x: eyeToEyeCenter.x - hatWidth / 2,
                                   y: eyeToEyeCenter.y - (hatHeight + 75),
                                   width: hatWidth,
                                   height: hatHeight)
            
            let angle = faceAnalyzer.leftToRightEyeAngle()
            headImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    func showEyesView() {
        leftEyeImageView.isHidden = false
        rightEyeImageView.isHidden = false
    }
    
    func hideEyesView() {
        leftEyeImageView.isHidden = true
        rightEyeImageView.isHidden = true
    }
    
    func showEyesViewWithFaceItem(_ faceItem: FaceItem) {
        leftEyeImageView.image = UIImage(named: faceItem.imageName)
        leftEyeImageView.anchorTo(point: faceItem.anchorPoint)
        rightEyeImageView.image = UIImage(named: faceItem.imageName)
        rightEyeImageView.anchorTo(point: faceItem.anchorPoint)
        
    }
    
    func repositionEyesView(usingAnalyzer faceAnalyzer: FaceAnalyzer) {
        if faceAnalyzer.isReady(),
            !leftEyeImageView.isHidden,
            !rightEyeImageView.isHidden,
            leftEyeImageView.image != nil,
            rightEyeImageView.image != nil {
            
            let leftImageWidth = faceAnalyzer.leftEyeWidth() + 20
            let leftEyeCenter = faceAnalyzer.leftEyeCenter()
            let leftImageAngle = faceAnalyzer.leftEyeAngle()
            
            placeImageView(leftEyeImageView,
                           center: leftEyeCenter,
                           width: leftImageWidth,
                           angle: leftImageAngle)
            
            let rightImageWidth = faceAnalyzer.rightEyeWidth() + 20
            let rightEyeCenter = faceAnalyzer.rightEyeCenter()
            let rightImageAngle = faceAnalyzer.rightEyeAngle()
            
            placeImageView(rightEyeImageView,
                           center: rightEyeCenter,
                           width: rightImageWidth,
                           angle: rightImageAngle)
            
        }
    }
    
    func showNoseView() {
        noseImageView.isHidden = false
    }
    
    func hideNoseView() {
        noseImageView.isHidden = true
    }
    
    func showNoseViewWithFaceItem(_ faceItem: FaceItem) {
        noseImageView.image = UIImage(named: faceItem.imageName)
        noseImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionNoseView(usingAnalyzer faceAnalyzer: FaceAnalyzer) {
        if faceAnalyzer.isReady(),
            !noseImageView.isHidden,
            noseImageView.image != nil {
            
            let width = faceAnalyzer.noseWidth() + 20
            let center = faceAnalyzer.noseCenter()
            let angle = faceAnalyzer.noseAngle()
            
            placeImageView(noseImageView,
                           center: center,
                           width: width,
                           angle: angle)
        }
    }
    
    func hideFacePoints() {
        for view in pointViews {
            view.isHidden = true
        }
    }
    
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
    
}
