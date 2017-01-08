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
    
//    var animatedHeartsTimer:Timer?
//    var animatedHearts = [UIImageView]()

    let heartAnimation:Animatable = HeartAnimation()
    
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
    
    func startAnimatingHearts(usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        self.heartAnimation.startAnimating(in: self.view, usingAnalyzer: faceAnalyzer)
    }
    
    func updateAnimatingHearts(faceAnalyzer:FaceAnalyzer) {
        self.heartAnimation.update(faceAnalyzer: faceAnalyzer)
    }
    
    func stopAnimatingHearts() {
        self.heartAnimation.stopAnimating()
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
        
        headImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
    }
    
    func showEyesView() {
        showLeftEyeView()
        showRightEyeView()
    }
    
    func hideEyesView() {
        hideLeftEyeView()
        hideRightEyeView()
    }
    
    func showEyesViewWithFaceItem(_ faceItem: FaceItem) {
        showLeftEyeViewWithFaceItem(faceItem)
        showRightEyeViewWithFaceItem(faceItem)
    }
    
    func repositionEyesView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        repositionLeftEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: faceItem)
        repositionRightEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: faceItem)
    }
    
    func showLeftEyeView() {
        leftEyeImageView.isHidden = false
    }
    
    func hideLeftEyeView() {
        leftEyeImageView.isHidden = true
    }
    
    func showLeftEyeViewWithFaceItem(_ faceItem: FaceItem) {
        leftEyeImageView.image = UIImage(named: faceItem.imageName)
        leftEyeImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionLeftEyeView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !leftEyeImageView.isHidden,
            leftEyeImageView.image != nil {
            
            leftEyeImageView.adjustLayoutFor(faceItem: faceItem.withPosition(.leftEye), usingAnalyzer: faceAnalyzer)
            
        }
    }
    
    func showRightEyeView() {
        rightEyeImageView.isHidden = false
    }
    
    func hideRightEyeView() {
        rightEyeImageView.isHidden = true
    }
    
    func showRightEyeViewWithFaceItem(_ faceItem: FaceItem) {
        rightEyeImageView.image = UIImage(named: faceItem.imageName)
        rightEyeImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionRightEyeView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !rightEyeImageView.isHidden,
            rightEyeImageView.image != nil {
            
            rightEyeImageView.adjustLayoutFor(faceItem: faceItem.withPosition(.rightEye), usingAnalyzer: faceAnalyzer)
            
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
            
            noseImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
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
            
            lipImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
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
            
            mouthImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
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
