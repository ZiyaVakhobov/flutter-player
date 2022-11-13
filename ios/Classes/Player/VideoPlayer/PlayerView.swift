//
//  PlayerView.swift
//  udevs_video_player
//
//  Created by Sunnatillo Shavkatov on 13/11/22.
//

import AVKit
import GoogleCast
import AVFoundation
import TinyConstraints
import NVActivityIndicatorView

protocol PlayerViewDelegate: NSObjectProtocol {
    func close(duration: Double)
    func settingsPressed()
    func episodesButtonPressed()
    func showPressed()
    func changeOrientation()
    func togglePictureInPictureMode()
}

class PlayerView: UIView {
    
    private var player = AVPlayer()
    var playerLayer =  AVPlayerLayer()
    var playerConfiguration: PlayerConfiguration!
    weak var delegate: PlayerViewDelegate?
    
    private var timer: Timer?
    private var seekForwardTimer: Timer?
    private var seekBackwardTimer: Timer?
    private var swipeGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    private var tapHideGesture: UITapGestureRecognizer!
    private var panDirection = SwipeDirection.vertical
    private var isVolume = false
    private var volumeViewSlider: UISlider!
    
    private var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor =  .clear
        return view
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var titleLabelPortrait: TitleLabel = TitleLabel()
    private var titleLabelLandacape: TitleLabel = TitleLabel()
    
    private var liveLabel: UILabel = {
        let label = UILabel()
        label.text = "LIVE"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.isHidden = true
        return label;
    }()
    
    private var liveCircle: UIView = {
        let circle = UIView(frame: CGRect(x:6,y:5,width: 12, height: 12))
        circle.layer.cornerRadius = (circle.frame.size.width) / 2
        circle.backgroundColor = .red
        let newCircle = UIView()
        newCircle.addSubview(circle)
        newCircle.isHidden = true
        return newCircle
    }()
    
    private lazy var liveStackView: UIStackView = {
        let liveView = UIStackView(arrangedSubviews: [liveCircle, liveLabel])
        liveView.height(20)
        liveView.sizeToFit()
        liveView.axis = .horizontal
        liveView.distribution = .equalSpacing
        return liveView
    }()
    
    private var landscapeButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.portrait.uiImage, for: .normal)
        button.addTarget(self, action: #selector(changeOrientation(_:)), for: .touchUpInside)
        return button
    }()
    
    private var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var durationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var seperatorLabel: UILabel = {
        let label = UILabel()
        label.text = " / "
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var timeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Colors.mainColor
        slider.maximumTrackTintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private var exitButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.exit.uiImage, for: .normal)
        button.addTarget(self, action: #selector(exitButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var pipButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.pip.uiImage, for: .normal)
        button.addTarget(self, action: #selector(togglePictureInPictureMode(_ :)), for: .touchUpInside)
        return button
    }()
    
    private var settingsButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.more.uiImage, for: .normal)
        button.addTarget(self, action: #selector(settingPressed(_ :)), for: .touchUpInside)
        return button
    }()
    
    private var playButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.play.uiImage, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var skipForwardButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.forward.uiImage, for: .normal)
        button.addTarget(self, action: #selector(skipForwardButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var skipBackwardButton: IconButton = {
        let button = IconButton()
        button.setImage(Svg.replay.uiImage, for: .normal)
        button.addTarget(self, action: #selector(skipBackButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var episodesButton: UIButton = {
        let button = UIButton()
        button.setImage(Svg.serial.uiImage, for: .normal)
        button.setTitle("", for: .normal)
        button.layer.zPosition = 3
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(episodesButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var showsBtn: UIButton = {
        let button = UIButton()
        button.setImage(Svg.programmes.uiImage, for: .normal)
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13,weight: .semibold)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showPressed), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicatorView: NVActivityIndicatorView = {
        let activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .circleStrokeSpin, color: .white)
        return activityView
    }()
    
    private var castButton: GCKUICastButton!
    
    private var playerRate = 1.0
    private var enableGesture = true
    private var backwardGestureTimer: Timer?
    private var forwardGestureTimer: Timer?
    private var backwardTouches = 0
    private var forwardTouches = 0
    
    func setIsPipEnabled(v:Bool){
        pipButton.isEnabled = v
    }
    
    func isHiddenPiP(isPiP: Bool){
        overlayView.isHidden = isPiP
    }
    
    func loadMedia(area:UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        uiSetup()
        addSubviews()
        pinchGesture()
        bottomView.clipsToBounds = true
        timeSlider.clipsToBounds = true
        addConstraints(area: area)
        addGestures()
        playButton.alpha = 0.0
        activityIndicatorView.startAnimating()
        loadMediaPlayer(urlString: playerConfiguration.url)
        runPlayer(startAt: playerConfiguration.lastPosition)
    }
    
    private func uiSetup(){
        episodesButton.setTitle(" "+playerConfiguration.episodeButtonText, for: .normal)
        showsBtn.setTitle(" "+playerConfiguration.tvProgramsText, for: .normal)
        if playerConfiguration.isLive {
            episodesButton.isHidden = true
        } else {
            showsBtn.isHidden = true
        }
        if #available(iOS 13.0, *) {
            setSliderThumbTintColor(Colors.mainColor)
        } else {
            timeSlider.thumbTintColor = Colors.moreColor
        }
        setTitle(title: playerConfiguration.title)
        castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                                   width: CGFloat(24), height: CGFloat(24)))
    }
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func setSliderThumbTintColor(_ color: UIColor) {
        let circleImage = makeCircleWith(size: CGSize(width: 24, height: 24),
                                         backgroundColor: color)
        timeSlider.setThumbImage(circleImage, for: .normal)
        timeSlider.setThumbImage(circleImage, for: .highlighted)
    }
    
    func loadMediaPlayer(urlString : String?){
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        player.automaticallyWaitsToMinimizeStalling = true
        player.replaceCurrentItem(with: AVPlayerItem(asset: AVURLAsset(url: url)))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        layer.insertSublayer(playerLayer, above: videoView.layer)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        if !playerConfiguration.isLive{
            NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
        }
        setTitle(title: playerConfiguration.title)
        addTimeObserver()
    }
    
    private func runPlayer(startAt: Int){
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(40000)
        player.automaticallyWaitsToMinimizeStalling = true;
        player.seek(to:CMTimeMakeWithSeconds(Float64(Float(startAt)),preferredTimescale: 1000))
        player.play()
    }
    
    func changeUrl(url:String?, title: String?){
        guard let videoURL = URL(string: url ?? "") else {
            return
        }
        self.setTitle(title: title)
        let playerItem = AVPlayerItem(asset: AVURLAsset(url: videoURL))
        self.player.replaceCurrentItem(with: playerItem)
        self.player.seek(to: CMTime.zero)
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(1)
        self.player.automaticallyWaitsToMinimizeStalling = true
        self.player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
    }
    
    func changeQuality(url:String?){
        guard let videoURL = URL(string: url ?? "") else {
            return
        }
        let currentTime = self.player.currentTime()
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.seek(to: currentTime)
        self.player.currentItem?.preferredForwardBufferDuration = TimeInterval(1)
        self.player.automaticallyWaitsToMinimizeStalling = true
    }
    
    func changeSpeed(rate: Double){
        self.playerRate = rate
        self.player.preroll(atRate: Float(self.playerRate), completionHandler: nil)
        self.player.rate = Float(self.playerRate)
    }
    
    func setTitle(title: String?){
        self.titleLabelPortrait.text = title ?? ""
        self.titleLabelLandacape.text = title ?? ""
    }
    
    @objc func exitButtonPressed(_ sender: UIButton){
        delegate?.close(duration: player.currentTime().seconds)
    }
    
    @objc func togglePictureInPictureMode(_ sender: UIButton){
        delegate?.close(duration: player.currentTime().seconds)
    }
    
    @objc func settingPressed(_ sender: UIButton){
        delegate?.settingsPressed()
    }
    
    @objc func changeOrientation(_ sender: UIButton){
        delegate?.changeOrientation()
    }
    
    @objc func episodesButtonPressed(_ sender: UIButton){
        delegate?.episodesButtonPressed()
    }
    
    @objc func showPressed(_ sender: UIButton){
        delegate?.showPressed()
    }
    
    @objc func skipBackButtonPressed(_ sender: UIButton){
        self.backwardTouches += 1
        self.seekBackwardTo(10.0 * Double(self.backwardTouches))
        self.backwardGestureTimer?.invalidate()
        self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.backwardTouches = 0
        }
        resetTimer()
    }
    
    @objc func skipForwardButtonPressed(_ sender: UIButton){
        self.forwardTouches += 1
        self.seekForwardTo(10.0 * Double(self.forwardTouches))
        self.forwardGestureTimer?.invalidate()
        self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.forwardTouches = 0
        }
        resetTimer()
    }
    
    @objc func playButtonPressed(_ sender: UIButton){
        if !player.isPlaying {
            player.play()
            playButton.setImage(Svg.pause.uiImage, for: .normal)
            self.player.preroll(atRate: Float(self.playerRate), completionHandler: nil)
            self.player.rate = Float(self.playerRate)
            resetTimer()
        } else {
            playButton.setImage(Svg.play.uiImage, for: .normal)
            player.pause()
            timer?.invalidate()
            showControls()
        }
    }
    
    @objc func hideControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 0.0
            topView.alpha = alpha
            skipForwardButton.alpha = alpha
            overlayView.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            skipBackwardButton.alpha = alpha
            bottomView.alpha = alpha
        }, completion: nil)
    }
    
    @objc func hideSeekForwardButton() {
        if topView.alpha == 0 {
            let options: UIView.AnimationOptions = [.curveEaseIn]
            UIView.animate(withDuration: 0.1, delay: 0.1, options: options, animations: {[self] in
                let alpha = 0.0
                skipForwardButton.alpha = alpha
            }, completion: nil)
        }
    }
    
    @objc func hideSeekBackwardButton() {
        if topView.alpha == 0 {
            let options: UIView.AnimationOptions = [.curveEaseIn]
            UIView.animate(withDuration: 0.1, delay: 0.1, options: options, animations: {[self] in
                let alpha = 0.0
                skipBackwardButton.alpha = alpha
            }, completion: nil)
        }
    }
    
    func showControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 1.0
            topView.alpha = alpha
            skipForwardButton.alpha = alpha
            skipBackwardButton.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            bottomView.alpha = alpha
        }, completion: nil)
        
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    private func pinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didpinch))
        videoView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func didpinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            if scale < 0.9 {
                self.playerLayer.videoGravity = .resizeAspect
            }else {
                self.playerLayer.videoGravity = .resizeAspectFill
            }
            resetTimer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame: CGRect = UIScreen.main.bounds
        overlayView.frame = frame
        videoView.frame = frame
        playerLayer.frame = frame
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            addVideosLandscapeConstraints()
        } else {
            addVideoPortaitConstraints()
        }
    }
    
    func addGestures(){
        swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipePan))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureControls))
        addGestureRecognizer(swipeGesture)
        addGestureRecognizer(tapGesture)
    }
    
    func addSubviews() {
        addSubview(videoView)
        addSubview(overlayView)
        overlayView.addSubview(topView)
        overlayView.addSubview(playButton)
        overlayView.addSubview(skipForwardButton)
        overlayView.addSubview(skipForwardButton)
        overlayView.addSubview(skipBackwardButton)
        overlayView.addSubview(skipBackwardButton)
        overlayView.addSubview(activityIndicatorView)
        overlayView.addSubview(bottomView)
        overlayView.addSubview(landscapeButton)
        overlayView.addSubview(topView)
        overlayView.addSubview(titleLabelPortrait)
        addTopViewSubviews()
        addBottomViewSubviews()
    }
    
    // MARK: - addBottomViewSubviews
    func addBottomViewSubviews() {
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(durationTimeLabel)
        bottomView.addSubview(seperatorLabel)
        bottomView.addSubview(timeSlider)
        bottomView.addSubview(episodesButton)
        bottomView.addSubview(showsBtn)
        bottomView.addSubview(landscapeButton)
        bottomView.addSubview(liveStackView)
    }
    
    func addTopViewSubviews() {
        topView.addSubview(exitButton)
        topView.addSubview(titleLabelLandacape)
        topView.addSubview(settingsButton)
        topView.addSubview(pipButton)
        topView.addSubview(castButton)
    }
    
    func addConstraints(area:UILayoutGuide) {
        addVideoPortaitConstraints()
        addBottomViewConstraints(area: area)
        addTopViewConstraints(area: area)
        addControlButtonConstraints()
    }
    
    private func addVideoPortaitConstraints() {
        titleLabelLandacape.isHidden = true
        titleLabelPortrait.isHidden = false
        landscapeButton.setImage(Svg.portrait.uiImage, for: .normal)
    }
    
    private func addVideosLandscapeConstraints() {
        titleLabelLandacape.isHidden = false
        titleLabelPortrait.isHidden = true
        landscapeButton.setImage(Svg.horizontal.uiImage, for: .normal)
    }
    
    func addControlButtonConstraints(){
        playButton.centerX(to: overlayView)
        playButton.centerY(to: overlayView)
        playButton.width(Constants.controlButtonSize)
        playButton.height(Constants.controlButtonSize)
        
        skipBackwardButton.width(Constants.controlButtonSize)
        skipBackwardButton.height(Constants.controlButtonSize)
        skipBackwardButton.rightToLeft(of: playButton, offset: -60)
        skipBackwardButton.top(to: playButton)
        
        skipForwardButton.width(Constants.controlButtonSize)
        skipForwardButton.height(Constants.controlButtonSize)
        skipForwardButton.leftToRight(of: playButton, offset: 60)
        skipForwardButton.top(to: playButton)
        
        activityIndicatorView.centerX(to: overlayView)
        activityIndicatorView.centerY(to: overlayView)
        activityIndicatorView.layer.cornerRadius = 20
        if playerConfiguration.isLive {
            skipForwardButton.isHidden = true
            skipBackwardButton.isHidden = true
        }
    }
    
    func addBottomViewConstraints(area:UILayoutGuide) {
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomView.trailing(to: area, offset: 0)
        bottomView.leading(to: area, offset: 0)
        bottomView.bottom(to: area, offset: 0)
        
        bottomView.height(82)
        
        timeSlider.bottom(to: bottomView, offset: -8)
        timeSlider.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        landscapeButton.bottomToTop(of: timeSlider, offset: 8)
        landscapeButton.snp.makeConstraints { make in
            make.right.equalTo(bottomView).offset(0)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(bottomView).offset(8)
        }
        currentTimeLabel.centerY(to: landscapeButton)
        
        seperatorLabel.leftToRight(of: currentTimeLabel)
        seperatorLabel.centerY(to: currentTimeLabel)
        
        durationTimeLabel.leftToRight(of: seperatorLabel)
        durationTimeLabel.centerY(to: seperatorLabel)
        
        
        episodesButton.rightToLeft(of: landscapeButton, offset: -8)
        episodesButton.centerY(to: landscapeButton)
        
        showsBtn.rightToLeft(of: landscapeButton, offset: -8)
        showsBtn.centerY(to: landscapeButton)
        
        liveStackView.bottomToTop(of: timeSlider)
        liveStackView.spacing = 24
        liveStackView.leftToSuperview(offset: 2)
        liveStackView.centerY(to: landscapeButton)
        
        if !playerConfiguration.isSerial {
            episodesButton.isHidden = true
        }
        
        if playerConfiguration.isLive {
            liveCircle.isHidden = false
            liveLabel.isHidden = false
            currentTimeLabel.isHidden = true
            durationTimeLabel.isHidden = true
            seperatorLabel.isHidden = true
        }
    }
    
    func addTopViewConstraints(area:UILayoutGuide) {
        topView.leading(to: area, offset: 0)
        topView.trailing(to: area, offset: 0)
        topView.top(to: area, offset: 0)
        topView.height(48)
        
        exitButton.left(to: topView)
        exitButton.centerY(to: topView)
        //
        settingsButton.right(to: topView)
        settingsButton.centerY(to: topView)
        
        castButton.rightToLeft(of: settingsButton)
        castButton.centerY(to: topView)
        
        pipButton.leftToRight(of: exitButton)
        pipButton.centerY(to: topView)
        
        titleLabelLandacape.centerY(to: topView)
        titleLabelLandacape.centerX(to: topView)
        titleLabelLandacape.rightToLeft(of: castButton)
        titleLabelLandacape.leftToRight(of: pipButton)
        titleLabelLandacape.layoutMargins = .horizontal(8)
        titleLabelPortrait.centerX(to: overlayView)
        titleLabelPortrait.topToBottom(of: topView, offset: 8)
        titleLabelPortrait.layoutMargins = .horizontal(24)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationTimeLabel.text = VGPlayerUtils.getTimeString(from: player.currentItem!.duration)
        }
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if newValue != oldValue {
                DispatchQueue.main.async {[weak self] in
                    if newValue == 2 {
                        self?.playButton.setImage(Svg.pause.uiImage, for: .normal)
                        self?.playButton.alpha = self?.skipBackwardButton.alpha ?? 0.0
                        self?.activityIndicatorView.stopAnimating()
                        self?.enableGesture = true
                    } else if newValue == 0 {
                        self?.playButton.setImage(Svg.play.uiImage, for: .normal)
                        self?.playButton.alpha = self?.skipBackwardButton.alpha ?? 0.0
                        self?.activityIndicatorView.stopAnimating()
                        self?.enableGesture = true
                        self?.timer?.invalidate()
                        self?.showControls()
                    } else {
                        self?.playButton.alpha = 0.0
                        self?.activityIndicatorView.startAnimating()
                        self?.enableGesture = false
                    }
                }
            }
        }
    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {[weak self] in
            self?.player.seek(to: CMTime.zero)
            self?.playButton.setImage(Svg.play.uiImage, for: .normal)
        }
    }
    
    @objc func swipePan() {
        let locationPoint = swipeGesture.location(in: overlayView)
        
        let velocityPoint = swipeGesture.velocity(in: overlayView)
        
        switch swipeGesture.state {
        case .began:
            
            let x = abs(velocityPoint.x)
            let y = abs(velocityPoint.y)
            
            if x > y {
                panDirection = SwipeDirection.horizontal
            } else {
                panDirection = SwipeDirection.vertical
                if locationPoint.x > overlayView.bounds.size.width / 2 {
                    isVolume = true
                } else {
                    isVolume = false
                }
            }
            
        case UIGestureRecognizer.State.changed:
            switch panDirection {
            case SwipeDirection.horizontal:
                //                horizontalMoved(velocityPoint.x)
                break
            case SwipeDirection.vertical:
                verticalMoved(velocityPoint.y)
                break
            }
            
        case UIGestureRecognizer.State.ended:
            switch panDirection {
            case SwipeDirection.horizontal:
                break
            case SwipeDirection.vertical:
                isVolume = false
                break
            }
        default:
            break
        }
    }
    
    func verticalMoved(_ value: CGFloat) {
        if isVolume {
            self.volumeViewSlider.value -= Float(value / 10000)
        }
        else{
            UIScreen.main.brightness -= value / 10000
        }
    }
    
    func showBlockControls(){
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            let alpha = 1.0
            topView.alpha = alpha
            resetTimer()
        }, completion: nil)
    }
    
    
    func toggleViews() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.05, delay: 0, options: options, animations: {[self] in
            let alpha = topView.alpha == 0.0 ? 1.0 : 0.0
            topView.alpha = alpha
            overlayView.alpha = alpha
            skipForwardButton.alpha = alpha
            skipBackwardButton.alpha = alpha
            if enableGesture {
                playButton.alpha = alpha
            }
            
            bottomView.alpha = alpha
            
            if(alpha == 1.0){
                resetTimer()
            }
        }, completion: nil)
    }
    
    func fastForward() {
        self.forwardTouches += 1
        if forwardTouches < 2{
            self.forwardGestureTimer?.invalidate()
            self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.forwardTouches = 0
                self.toggleViews()
            }
        } else {
            self.showSeekForwardButton()
            self.seekForwardTo(10.0 * Double(self.forwardTouches))
            self.forwardGestureTimer?.invalidate()
            self.forwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.forwardTouches = 0
                self.resetSeekForwardTimer()
            }
        }
    }
    func fastBackward() {
        self.backwardTouches += 1
        if backwardTouches < 2{
            self.backwardGestureTimer?.invalidate()
            self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                self.backwardTouches = 0
                self.toggleViews()
            }
        } else {
            self.showSeekBackwardButton()
            self.seekBackwardTo(10.0 * Double(self.backwardTouches))
            self.backwardGestureTimer?.invalidate()
            self.backwardGestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.backwardTouches = 0
                self.resetSeekBackwardTimer()
            }
        }
    }
    
    func resetSeekForwardTimer() {
        seekForwardTimer?.invalidate()
        seekForwardTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hideSeekForwardButton), userInfo: nil, repeats: false)
    }
    
    func resetSeekBackwardTimer() {
        seekBackwardTimer?.invalidate()
        seekBackwardTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hideSeekBackwardButton), userInfo: nil, repeats: false)
    }
    
    func showSeekForwardButton(){
        skipForwardButton.alpha = 1.0
    }
    func showSeekBackwardButton(){
        skipBackwardButton.alpha = 1.0
    }
    
    @objc func hideBlockControls() {
        let options: UIView.AnimationOptions = [.curveEaseIn]
        UIView.animate(withDuration: 0.3, delay: 0.2, options: options, animations: {[self] in
            _ = 0.0
        }, completion: nil)
    }

    
    @objc func tapGestureControls() {
        
        let location = tapGesture.location(in: overlayView)
        
        if location.x > overlayView.bounds.width / 2 + 50 {
            self.fastForward()
        } else if location.x <= overlayView.bounds.width / 2 - 50 {
            self.fastBackward()
        } else {
            toggleViews()
        }
    }
    
    fileprivate func seekForwardTo(_ seekPosition: Double) {
        guard let duration = player.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + seekPosition
        if newTime < (CMTimeGetSeconds(duration) - seekPosition) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
    }
    
    fileprivate func seekBackwardTo(_ seekPosition: Double) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - seekPosition
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    //MARK: - Time logic
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        if(!playerConfiguration.isLive){
            player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
                guard let currentItem = self?.player.currentItem else {return}
                
                guard currentItem.duration >= .zero, !currentItem.duration.seconds.isNaN else {
                    return
                }
                self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
                self?.timeSlider.minimumValue = 0
                self?.timeSlider.value = Float(currentItem.currentTime().seconds)
                self?.currentTimeLabel.text = VGPlayerUtils.getTimeString(from: currentItem.currentTime())
            })
        } else{
            self.timeSlider.value = 1
        }
    }
    
}
