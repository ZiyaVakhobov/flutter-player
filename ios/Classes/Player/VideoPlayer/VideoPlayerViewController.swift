//
//  VideoPlayerViewController.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//

import UIKit
import TinyConstraints
import AVFoundation
import AVKit
import MediaPlayer
import XLActionController
import NVActivityIndicatorView
import SnapKit
import GoogleCast

/* The player state. */
enum PlaybackMode: Int {
    case none = 0
    case local
    case remote
}

class VideoPlayerViewController: UIViewController, AVPictureInPictureControllerDelegate,  GCKRequestDelegate, SettingsBottomSheetCellDelegate, BottomSheetCellDelegate, PlayerViewDelegate {
    
    private var speedList = ["2.0","1.5","1.25","1.0","0.5"].sorted()
    
    private var pipController: AVPictureInPictureController!
    private var pipPossibleObservation: NSKeyValueObservation?
    private var playerItemContext = 0
    /// chrome cast
    private var sessionManager: GCKSessionManager!
    private var castMediaController: GCKUIMediaController!
    private var volumeController: GCKUIDeviceVolumeController!
    private var streamPositionSliderMoving: Bool = false
    private var playbackMode = PlaybackMode.none
    private var queueButton: UIBarButtonItem!
    private var showStreamTimeRemaining: Bool = false
    private var localPlaybackImplicitlyPaused: Bool = false
    //    private var actionSheet: ActionSheet?
    private var queueAdded: Bool = false
    ///
    weak var delegate: VideoPlayerDelegate?
    private var url: String?
    var qualityLabelText = ""
    var speedLabelText = ""
    var selectedSeason: Int = 0
    var selectSesonNum: Int = 0
    var isRegular: Bool = false
    var resolutions: [String:String]?
    var sortedResolutions: [String] = []
    var seasons : [Season] = [Season]()
    var shouldHideHomeIndicator = false
    var qualityDelegate: QualityDelegate!
    var speedDelegte: SpeedDelegate!
    var playerConfiguration: PlayerConfiguration!
    private var isVolume = false
    private var volumeViewSlider: UISlider!
    private var playerRate = 1.0
    private var selectedSpeedText = "1.0x"
    var selectedQualityText = "Auto"
    
    private var playerView: PlayerView = {
        return PlayerView()
    }()
    
    private var portraitConstraints = Constraints()
    private var landscapeConstraints = Constraints()
    
    init() {
        sessionManager = GCKCastContext.sharedInstance().sessionManager
        castMediaController = GCKUIMediaController()
        volumeController = GCKUIDeviceVolumeController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported() {
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pipController = AVPictureInPictureController(playerLayer: playerView.playerLayer)
            pipController.delegate = self
            
            pipPossibleObservation = pipController.observe(\AVPictureInPictureController.isPictureInPicturePossible,
                                                            options: [.initial, .new]) { [weak self] _, change in
                // Update the PiP button's enabled state.
                self?.playerView.setIsPipEnabled(v: change.newValue ?? false)
            }
        } else {
            // PiP isn't supported by the current device. Disable the PiP button.
            playerView.setIsPipEnabled(v: false)
        }
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        playerView.isHiddenPiP(isPiP: true)
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        playerView.isHiddenPiP(isPiP: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = playerConfiguration.url
        let resList = resolutions ?? ["480p":playerConfiguration.url]
        sortedResolutions = Array(resList.keys).sorted().reversed()
        Array(resList.keys).sorted().reversed().forEach { quality in
            if quality == "1080p"{
                sortedResolutions.removeLast()
                sortedResolutions.insert("1080p", at: 1)
            }
        }
        if #available(iOS 13.0, *) {
            let value = UIInterfaceOrientationMask.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        view.backgroundColor = .black
        
        playerView.delegate = self
        playerView.playerConfiguration = playerConfiguration
        view.addSubview(playerView)
        playerView.edgesToSuperview()
        setupPictureInPicture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
    }
    
    @objc func castDeviceDidChange(_: Notification) {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
            // You can present the instructions on how to use Google Cast on
            // the first time the user uses you app
            GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: playerView.castButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self?.isCastControlBarsEnabled = true
        if playbackMode == .local, localPlaybackImplicitlyPaused {
            localPlaybackImplicitlyPaused = false
        }
        // If we're in remote playback but no longer have a session, then switch to local playback
        // mode. If we're in local mode but now have a session, then switch to remote playback mode.
        let hasConnectedSession: Bool = (sessionManager.hasConnectedSession())
        print("hasConnectedSession")
        print(hasConnectedSession)
        print(playbackMode)
        if hasConnectedSession, (playbackMode != .remote) {
            populateMediaInfo(false, playPosition: 0)
            switchToRemotePlayback()
        } else if sessionManager.currentSession == nil, (playbackMode != .local) {
            switchToLocalPlayback()
        } else {
            populateMediaInfo(false, playPosition: 0)
        }
        sessionManager.add(self)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureVolume()
        self.shouldHideHomeIndicator = true
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        playerView.stop()
        playerView.removeMediaPlayerObservers()
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.setValue(UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playerView.updateConstraints()
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight{
            addVideosLandscapeConstraints()
        } else {
            addVideoPortaitConstraints()
        }
    }
    
    //MARK: - Hide Home Indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //@available(iOS 11, *)
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return nil
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    func populateMediaInfo(_ autoPlay: Bool, playPosition: TimeInterval) {
        print("populateMediaInfo")
        playerView.loadMedia(buildMediaInfo(position: playerView.streamPosition ?? 0, url: playerConfiguration.url), autoPlay: autoPlay, playPosition: playPosition, area: view.safeAreaLayoutGuide)
    }
    
    func switchToLocalPlayback() {
        print("switchToLocalPlayback")
        if playbackMode == .local {
            return
        }
        var playPosition: TimeInterval = 0
        var paused: Bool = false
        var ended: Bool = false
        if playbackMode == .remote {
            playPosition = castMediaController.lastKnownStreamPosition
            paused = (castMediaController.lastKnownPlayerState == .paused)
            ended = (castMediaController.lastKnownPlayerState == .idle)
            print("last player state: \(castMediaController.lastKnownPlayerState), ended: \(ended)")
        }
        populateMediaInfo((!paused && !ended), playPosition: playPosition)
        sessionManager.currentCastSession?.remoteMediaClient?.remove(self)
        playbackMode = .local
        playerView.playbackMode = playbackMode
    }
    
    func switchToRemotePlayback() {
        if playbackMode == .remote {
            return
        }
        // If we were playing locally, load the local media on the remote player
        if playbackMode == .local, (playerView.playerState != .stopped) {
            let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
            mediaLoadRequestDataBuilder.mediaInformation = buildMediaInfo(position: playerView.streamPosition ?? 0, url: playerConfiguration.url)
            mediaLoadRequestDataBuilder.autoplay = true
            mediaLoadRequestDataBuilder.startTime = playerView.streamPosition ?? 0
            mediaLoadRequestDataBuilder.credentials = "user-credentials"
            mediaLoadRequestDataBuilder.atvCredentials = "atv-user-credentials"
            
            let request = sessionManager.currentCastSession?.remoteMediaClient?.loadMedia(with: mediaLoadRequestDataBuilder.build())
            request?.delegate = self
        }
        sessionManager.currentCastSession?.remoteMediaClient?.add(self)
        playbackMode = .remote
        playerView.playbackMode = playbackMode
        playerView.stop()
    }
    
    private func loadRemoteMedia(){
        if sessionManager == nil {
            return
        }
        let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
        mediaLoadRequestDataBuilder.mediaInformation = buildMediaInfo(position: playerView.streamPosition ?? 0, url: url ?? "")
        mediaLoadRequestDataBuilder.autoplay = true
        mediaLoadRequestDataBuilder.startTime = playerView.streamPosition ?? 0
        mediaLoadRequestDataBuilder.credentials = "user-credentials"
        mediaLoadRequestDataBuilder.atvCredentials = "atv-user-credentials"
        let request = sessionManager.currentCastSession?.remoteMediaClient?.loadMedia(with: mediaLoadRequestDataBuilder.build())
        request?.delegate = self
    }
    
    func buildMediaInfo(position: Double, url : String)-> GCKMediaInformation {
        /*GCKMediaMetadata configuration*/
        var metadata = GCKMediaMetadata()
        metadata.setString(playerConfiguration.title, forKey: kGCKMetadataKeyTitle)
        
        /*Loading media to cast by creating a media request*/
        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: URL(string:
                                                                            url)!)
        mediaInfoBuilder.streamType = GCKMediaStreamType.buffered
        mediaInfoBuilder.contentType = "videos/m3u8"
        mediaInfoBuilder.metadata = metadata
        mediaInfoBuilder.streamDuration = position
        return mediaInfoBuilder.build()
    }
    
    private func addVideosLandscapeConstraints() {
        portraitConstraints.deActivate()
        landscapeConstraints.append(contentsOf: playerView.edgesToSuperview())
    }
    
    private func addVideoPortaitConstraints() {
        landscapeConstraints.deActivate()
        portraitConstraints.append(contentsOf: playerView.center(in: view))
        portraitConstraints.append(contentsOf: playerView.edgesToSuperview())
    }
    
    private func configureVolume() {
        let volumeView = MPVolumeView()
        for view in volumeView.subviews {
            if let slider = view as? UISlider {
                self.volumeViewSlider = slider
            }
        }
    }
    func skipForwardButtonPressed() {
        
    }
    
    func playButtonPressed() {
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
//        var remoteMediaClient =  !.
//        if (remoteMediaClient?.isPlaying == true) {
//            remoteMediaClient.pause()
//        } else {
//            remoteMediaClient?.play()
//        }
    }
    
    func showPressed() {
        let vc = ProgramViewController()
        vc.modalPresentationStyle = .custom
        vc.programInfo = self.playerConfiguration.programsInfoList
        vc.menuHeight = self.playerConfiguration.programsInfoList.isEmpty ? 250 : UIScreen.main.bounds.height * 0.75
        if !(vc.programInfo.isEmpty) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func close(duration:Double){
        self.dismiss(animated: true, completion: nil);
        delegate?.getDuration(duration: duration)
    }
    
    func changeOrientation(){
        var value  = UIInterfaceOrientation.landscapeRight.rawValue
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            value = UIInterfaceOrientation.portrait.rawValue
        }
        UIDevice.current.setValue(value, forKey: "orientation")
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return
            }
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) ? .portrait : .landscapeRight)){
                    error in
                    print(error)
                    print(windowScene.effectiveGeometry)
                }
            })
        } else{
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    func updateSeasonNum(index:Int) {
        selectedSeason = index
    }
    
    //MARK: - ****** SEASONS *******
    func episodesButtonPressed(){
        let episodeVC = EpisodeCollectionUI()
        episodeVC.modalPresentationStyle = .custom
        episodeVC.seasons = self.seasons
        episodeVC.delegate = self
        episodeVC.selectedSeasonIndex = selectedSeason
        self.present(episodeVC, animated: true, completion: nil)
    }
    
    func settingsPressed() {
        let vc = SettingVC()
        vc.modalPresentationStyle = .custom
        vc.delegete = self
        vc.speedDelegate = self
        vc.settingModel = [
            SettingModel(leftIcon: Svg.settings.uiImage, title: qualityLabelText, configureLabel: selectedQualityText),
            SettingModel(leftIcon: Svg.playSpeed.uiImage, title: speedLabelText, configureLabel:  selectedSpeedText)
        ]
        self.present(vc, animated: true, completion: nil)
    }
    
    func togglePictureInPictureMode() {
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "pip" {
            if self.pipController.isPictureInPictureActive {
                self.playerView.isHiddenPiP(isPiP: true)
            }else {
                self.playerView.isHiddenPiP(isPiP: false)
            }
        }
    }
    
    // settings bottom sheet tapped
    func onSettingsBottomSheetCellTapped(index: Int) {
        switch index {
        case 0:
            showQualityBottomSheet()
            break
        case 1:
            showSpeedBottomSheet()
            break
        case 2:
            //            showSubtitleBottomSheet()
            break
        case 3:
            //            showAudioTrackBottomSheet()
            break
        default:
            break
        }
    }
    
    //    //MARK: - Bottom Sheets Configurations
    // bottom sheet tapped
    func onBottomSheetCellTapped(index: Int, type : BottomSheetType) {
        switch type {
        case .quality:
            let resList = resolutions ?? ["480p":playerConfiguration.url]
            self.selectedQualityText = sortedResolutions[index]
            let url = resList[sortedResolutions[index]]
            self.playerView.changeQuality(url: url)
            break
        case .speed:
            self.playerRate = Double(speedList[index])!
            self.selectedSpeedText = isRegular  ? "\(self.playerRate)x(Обычный)" : "\(self.playerRate)x"
            self.playerView.changeSpeed(rate: self.playerRate)
            break
        case .subtitle:
            
            break
        case .audio:
            break
        }
    }
    
    func showQualityBottomSheet(){
        let resList = resolutions ?? ["480p": playerConfiguration.url]
        let array = Array(resList.keys)
        var listOfQuality = [String]()
        listOfQuality = array.sorted().reversed()
        array.sorted().reversed().forEach { quality in
            if quality == "1080p"{
                listOfQuality.removeLast()
                listOfQuality.insert("1080p", at: 1)
            }
        }
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.items = listOfQuality
        bottomSheetVC.labelText = qualityLabelText
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.bottomSheetType = .quality
        bottomSheetVC.selectedIndex = listOfQuality.firstIndex(of: selectedQualityText) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
    
    func showSpeedBottomSheet(){
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.items = speedList
        bottomSheetVC.labelText = speedLabelText
        bottomSheetVC.cellDelegate = self
        bottomSheetVC.bottomSheetType = .speed
        bottomSheetVC.selectedIndex = speedList.firstIndex(of: "\(self.playerRate)") ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(bottomSheetVC, animated: false, completion:nil)
        }
    }
    
    
    func getMegogoStream(parameters:[String:String], id:String) -> MegogoStreamResponse? {
        var megogoResponse:MegogoStreamResponse?
        let _url:String = playerConfiguration.baseUrl+"megogo/stream"
        let result = Networking.sharedInstance.getMegogoStream(_url, token: self.playerConfiguration.authorization, sessionId: id, parameters: parameters)
        switch result {
        case .failure(let error):
            print(error)
            break
        case .success(let success):
            megogoResponse = success
            break
        }
        return megogoResponse
        
    }
    
    func getPremierStream(episodeId:String) -> PremierStreamResponse?{
        let _url : String = playerConfiguration.baseUrl+"premier/videos/\(playerConfiguration.videoId)/episodes/\(episodeId)/stream"
        var premierSteamResponse: PremierStreamResponse?
        let result = Networking.sharedInstance.getPremierStream(_url, token: playerConfiguration.authorization, sessionId: playerConfiguration.sessionId)
        switch result {
        case .failure(let error):
            print(error)
        case .success(let success):
            premierSteamResponse = success
        }
        return premierSteamResponse
    }
    
    func playSeason(_resolutions : [String:String],startAt:Int64?,_episodeIndex:Int,_seasonIndex:Int ){
        self.selectedSeason = _seasonIndex
        self.selectSesonNum = _episodeIndex
        self.resolutions = SortFunctions.sortWithKeys(_resolutions)
        let isFinded = resolutions?.contains(where: { (key, value) in
            if key == self.selectedQualityText {
                return true
            }
            return false
        }) ?? false
        let title = seasons[_seasonIndex].movies[_episodeIndex].title ?? ""
        if isFinded {
            let videoUrl = self.resolutions?[selectedQualityText]
            guard videoUrl != nil else{
                return
            }
            guard URL(string: videoUrl!) != nil else {
                return
            }
            if self.playerConfiguration.url != videoUrl!{
                if playbackMode == .local{
                    self.playerView.changeUrl(url: videoUrl, title: "S\(_seasonIndex + 1)" + " " + "E\(_episodeIndex + 1)" + " \u{22}\(title)\u{22}" )
                    self.url = videoUrl
                } else {
                    self.url = videoUrl
                    loadRemoteMedia()
                }
            } else {
                print("ERROR")
            }
            return
        } else if !self.resolutions!.isEmpty {
            if playbackMode == .local {
                let videoUrl = Array(resolutions!.values)[0]
                self.playerView.changeUrl(url: videoUrl, title: title)
                self.url = videoUrl
            } else {
                let videoUrl = Array(resolutions!.values)[0]
                self.url = videoUrl
                loadRemoteMedia()
            }
            return
        }
    }
}

extension VideoPlayerViewController: GCKSessionManagerListener, GCKRemoteMediaClientListener {
    // MARK: - GCKSessionManagerListener
    func sessionManager(_: GCKSessionManager, didStart session: GCKSession) {
        print("MediaViewController: sessionManager didStartSession \(session)")
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_: GCKSessionManager, didResumeSession session: GCKSession) {
        print("MediaViewController: sessionManager didResumeSession \(session)")
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_: GCKSessionManager, didEnd _: GCKSession, withError error: Error?) {
        print("session ended with error: \(String(describing: error))")
        self.switchToLocalPlayback()
    }
}

extension VideoPlayerViewController: QualityDelegate, SpeedDelegate, EpisodeDelegate {
    
    func onEpisodeCellTapped(seasonIndex: Int, episodeIndex: Int) {
        var resolutions: [String:String] = [:]
        var startAt :Int64?
        let episodeId : String = seasons[seasonIndex].movies[episodeIndex].id ?? ""
        if playerConfiguration.isMegogo {
            let parameters : [String:String] = ["video_id":episodeId,"access_token":self.playerConfiguration.megogoAccessToken]
            var success : MegogoStreamResponse?
            success = self.getMegogoStream(parameters: parameters,id: episodeId)
            if success != nil {
                
                resolutions[self.playerConfiguration.autoText] = success?.data.src
                success?.data.bitrates.forEach({ bitrate in
                    resolutions["\(bitrate.bitrate)p"] = bitrate.src
                })
                startAt = Int64(success?.data.playStartTime ?? 0)
                self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if playerConfiguration.isPremier {
            var success : PremierStreamResponse?
            success = self.getPremierStream(episodeId: episodeId)
            if success != nil {
                success?.fileInfo.forEach({ file in
                    if file.quality == "auto"{
                        resolutions[self.playerConfiguration.autoText] = file.fileName
                    } else {
                        resolutions["\(file.quality)"] = file.fileName
                    }
                })
                startAt = 0
                self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
            }
        }
        if !playerConfiguration.isMegogo && !playerConfiguration.isPremier {
            seasons[seasonIndex].movies[episodeIndex].resolutions.map { (key: String, value: String) in
                resolutions[key] = value
                startAt = 0
            }
            self.playSeason(_resolutions: resolutions, startAt: startAt, _episodeIndex: episodeIndex, _seasonIndex: seasonIndex)
        }
    }
    
    func speedBottomSheet() {
        showSpeedBottomSheet()
    }
    func qualityBottomSheet() {
        showQualityBottomSheet()
    }
}
// 1170

/** A key for the URL of the media item's poster (large image). */
let kMediaKeyPosterURL = "posterUrl"
/** A key for the media item's extended description. */
let kMediaKeyDescription = "description"
let kKeyCategories = "categories"
let kKeyHlsBaseURL = "hls"
let kKeyImagesBaseURL = "images"
let kKeyTracksBaseURL = "tracks"
let kKeySources = "sources"
let kKeyVideos = "videos"
let kKeyArtist = "artist"
let kKeyBaseURL = "baseUrl"
let kKeyContentID = "contentId"
let kKeyDescription = "description"
let kKeyID = "id"
let kKeyImageURL = "image-480x270"
let kKeyItems = "items"
let kKeyLanguage = "language"
let kKeyMimeType = "mime"
let kKeyName = "name"
let kKeyPosterURL = "image-780x1200"
let kKeyStreamType = "streamType"
let kKeyStudio = "studio"
let kKeySubtitle = "subtitle"
let kKeySubtype = "subtype"
let kKeyTitle = "title"
let kKeyTracks = "tracks"
let kKeyType = "type"
let kKeyURL = "url"
let kKeyDuration = "duration"
let kDefaultVideoMimeType = "application/x-mpegurl"
let kDefaultTrackMimeType = "text/vtt"
let kTypeAudio = "audio"
let kTypePhoto = "photos"
let kTypeVideo = "videos"
let kTypeLive = "live"
let kThumbnailWidth = 480
let kThumbnailHeight = 720
let kPosterWidth = 780
let kPosterHeight = 1200
