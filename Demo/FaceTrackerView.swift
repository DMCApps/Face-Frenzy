import UIKit
import FaceTracker

class FaceTrackerView: UIViewController, FaceTrackerViewOps, FaceTrackerViewControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var faceTrackerContainerView: UIView!
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
        guard faceAnalyzer.isReady(), !headImageView.isHidden, headImageView.image != nil else {
                return
        }
        
        let width = faceAnalyzer.outerEyeDistance()
        let center = faceAnalyzer.eyeToEyeCenter()
        let angle = faceAnalyzer.leftToRightEyeAngle()
        
        headImageView.adjustLayoutFor(faceItem: faceItem,
                                      center: center,
                                      width: width,
                                      angle: angle)
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
            
            // TODO: Feel like the presenter should be dealing with this
            let leftImageWidth = faceAnalyzer.leftEyeWidth()
            let leftEyeCenter = faceAnalyzer.leftEyeCenter()
            let leftImageAngle = faceAnalyzer.leftEyeAngle()
            
            leftEyeImageView.adjustLayoutFor(faceItem: faceItem,
                                             center: leftEyeCenter,
                                             width: leftImageWidth,
                                             angle: leftImageAngle)
            
            // TODO: Feel like the presenter should be dealing with this
            let rightImageWidth = faceAnalyzer.rightEyeWidth()
            let rightEyeCenter = faceAnalyzer.rightEyeCenter()
            let rightImageAngle = faceAnalyzer.rightEyeAngle()
            
            rightEyeImageView.adjustLayoutFor(faceItem: faceItem,
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
            
            let width = faceAnalyzer.noseWidth()
            let center = faceAnalyzer.noseCenter()
            let angle = faceAnalyzer.noseAngle()
            
            noseImageView.adjustLayoutFor(faceItem: faceItem,
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
            
            let width = faceAnalyzer.outerMouthWidth()
            let center = faceAnalyzer.betweenMouthAndNoseCenter()
            let angle = faceAnalyzer.outerMouthAngle()
            
            lipImageView.adjustLayoutFor(faceItem: faceItem,
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
            
            let width = faceAnalyzer.innerMouthWidth()
            let center = faceAnalyzer.innerMouthCenter()
            let angle = faceAnalyzer.innerMouthAngle()
            
            mouthImageView.adjustLayoutFor(faceItem: faceItem,
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
        self.startTranslationConstraintConstant = self.ibActionMenuTopToContainerConstraint.constant
    }
    
    func didTranslateBy(_ translation: CGFloat) {
        guard let startTranslationConstraintConstant = self.startTranslationConstraintConstant else {
            return
        }
        
        var newConstraintConstant = startTranslationConstraintConstant + translation
        newConstraintConstant = newConstraintConstant.clamp(to: (30 ... 190))
        animateActionMenuTo(newConstraintConstant, withDuration: 0.05)
    }
    
    func didEndTranslation() {
        self.startTranslationConstraintConstant = nil
    }
    
}
