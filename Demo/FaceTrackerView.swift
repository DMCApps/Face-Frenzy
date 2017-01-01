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
    var lipImageView = UIImageView()
    var mouthImageView = UIImageView()
    
    var animatedHeartsTimer:Timer?
    var animatedHearts = [UIImageView]()
    
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
        self.view.insertSubview(lipImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(mouthImageView, aboveSubview: faceTrackerContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTrackerViewController!.startTracking { () -> Void in
            self.presenter.faceTrackerDidFinishLoading()
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
    
    func stopLoadingAnimation() {
        self.activityIndicator.stopAnimating()
    }
    
    func positionFacePoints(_ points:FacePoints) {
        if (pointViews.count == 0) {
            let numPoints = points.getTotalNumberOFPoints()
            for _ in 0...numPoints {
                let view = UIView()
                view.backgroundColor = UIColor.green
                self.view.addSubview(view)
                
                pointViews.append(view)
            }
        }
        
        points.enumeratePoints({ (point, index) -> Void in
            let pointView = self.pointViews[index]
            let pointSize: CGFloat = 4
            
            pointView.frame = CGRect(x: point.x - pointSize / 2,
                                     y: point.y - pointSize / 2,
                                     width: pointSize,
                                     height: pointSize).integral
        })
    }
    
    func swapCamera() {
        faceTrackerViewController?.swapCamera()
    }
    
    func startAnimatingHearts() {
        self.animatedHeartsTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                        target: self,
                                                        selector: #selector(self.addRandomHeartAndAnimate),
                                                        userInfo: nil,
                                                        repeats: true);
    }
    
    func addRandomHeartAndAnimate() {
        let randomX = self.view.frame.size.width / 2 - 49 + CGFloat(arc4random_uniform(100))
        
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "heart")
        heartImageView.frame = CGRect(x: randomX,
                                      y: 200,
                                      width: heartImageView.image?.size.width ?? 50,
                                      height: heartImageView.image?.size.height ?? 50)
        heartImageView.alpha = 1.0
        
        self.animatedHearts.append(heartImageView)
        self.view.insertSubview(heartImageView, aboveSubview: faceTrackerContainerView)
        
        UIView.animate(withDuration: 1.2, animations: {
            heartImageView.center = CGPoint(x: heartImageView.center.x, y: heartImageView.center.y - 50)
            heartImageView.alpha = 0.0
        }) { [unowned self] (complete) in
            if complete {
                heartImageView.removeFromSuperview()
                // TODO: Probably more efficient to recycle these
                self.animatedHearts.remove(at: self.animatedHearts.index(of: heartImageView)!)
            }
        }
    }
    
    func stopAnimatingHearts() {
        self.animatedHeartsTimer?.invalidate()
        self.animatedHeartsTimer = nil
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
    
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !headImageView.isHidden,
            let image = headImageView.image {
            
            let hatWidth = 2.0 * faceAnalyzer.outerEyeDistance()
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
    
    func repositionEyesView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !leftEyeImageView.isHidden,
            !rightEyeImageView.isHidden,
            leftEyeImageView.image != nil,
            rightEyeImageView.image != nil {
            
            let leftImageWidth = faceAnalyzer.leftEyeWidth() + 20
            let leftEyeCenter = faceAnalyzer.leftEyeCenter() + faceItem.centerOffset
            let leftImageAngle = faceAnalyzer.leftEyeAngle()
            
            placeImageView(leftEyeImageView,
                           center: leftEyeCenter,
                           width: leftImageWidth,
                           angle: leftImageAngle)
            
            let rightImageWidth = faceAnalyzer.rightEyeWidth() + 20
            let rightEyeCenter = faceAnalyzer.rightEyeCenter() + faceItem.centerOffset
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
    
    func repositionNoseView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !noseImageView.isHidden,
            noseImageView.image != nil {
            
            let width = faceAnalyzer.noseWidth() + 20
            let center = faceAnalyzer.noseCenter() + faceItem.centerOffset
            let angle = faceAnalyzer.noseAngle()
            
            placeImageView(noseImageView,
                           center: center,
                           width: width,
                           angle: angle)
        }
    }
    
    func showLipView() {
        lipImageView.isHidden = false
    }
    
    func hideLipView() {
        lipImageView.isHidden = true
    }
    
    func showLipViewWithFaceItem(_ faceItem: FaceItem) {
        lipImageView.image = UIImage(named: faceItem.imageName)
        lipImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionLipView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !lipImageView.isHidden,
            lipImageView.image != nil {
            
            let width = faceAnalyzer.outerMouthWidth() + 60
            let center = faceAnalyzer.outerMouthCenter() + faceItem.centerOffset
            let angle = faceAnalyzer.outerMouthAngle()
            
            placeImageView(lipImageView,
                           center: center,
                           width: width,
                           angle: angle)
        }
    }
    
    func showMouthView() {
        mouthImageView.isHidden = false
    }
    
    func hideMouthView() {
        mouthImageView.isHidden = true
    }
    
    func showMouthViewWithFaceItem(_ faceItem: FaceItem) {
        mouthImageView.image = UIImage(named: faceItem.imageName)
        mouthImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionMouthView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !mouthImageView.isHidden,
            mouthImageView.image != nil {
            
            let width = faceAnalyzer.innerMouthWidth() + 20
            let center = faceAnalyzer.innerMouthCenter() + faceItem.centerOffset
            let angle = faceAnalyzer.innerMouthAngle()
            
            placeImageView(mouthImageView,
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
