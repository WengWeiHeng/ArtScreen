//
//  ARResultTestController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/24.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ARResultTestController: UIViewController {
    
    //MARK: - Properties
    var artwork: Artwork? {
        didSet {
            configureArtworkData()
            fetchArtworkItem()
        }
    }
    var artworkItem: ArtworkItem? {
        didSet {
            configureArtworkItemData()
        }
    }
    
    var circleWidth: CGFloat!
    var circleHeight: CGFloat!
    
    var trimImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var originImageView: UIImageView = {
        let iv = UIImageView()
        
        let iv2 = UIImageView()
        iv.addSubview(iv2)
        return iv
    }()
    
    // Emitter animate
    lazy var particleImage: UIImage = {
        let imageSize = CGSize(width: circleWidth, height: circleHeight)
        let margin: CGFloat = 0
        let circleSize = CGSize(width: imageSize.width - margin * 2, height: imageSize.height - margin * 2)
        UIGraphicsBeginImageContext(imageSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fillEllipse(in: CGRect(origin: CGPoint(x: margin, y: margin), size: circleSize))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return image!
    }()
    /// Emitter cells and layer
    var cells = [CAEmitterCell]()
    var emitter = CAEmitterLayer()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDarkGray
        view.addSubview(originImageView)
        originImageView.frame = view.frame
        originImageView.alpha = 0.75
        
        view.addSubview(trimImageView)
        
        print("DEBUG: trimImageView size in ARResult \(originImageView.frame.size)")
        
//        AnimateUtilities().rotateAction(view: trimImageView, fromValue: 2, toValue: 1, duration: 6)
    }
    
    //MARK: - API
    func fetchArtworkItem() {
        guard let artwork = artwork else { return }
        ArtworkItemService.fetchArtworkItems(withArtwork: artwork) { (artworkItem) in
            self.artworkItem = artworkItem
            print("DEBUG: ArtworkItem in Result: \(artworkItem)")
        }
    }
    
    //MARK: - Helpers
    func configureArtworkData() {
        guard let artwork = artwork else { return }
        originImageView.sd_setImage(with: artwork.artworkImageUrl)
    }
    
    func configureArtworkItemData() {
        guard let artworkItem = artworkItem else { return }
        guard let artwork = artwork else { return }
        let widthOriginal = CGFloat(artwork.width)
        let heightOriginal = CGFloat(artwork.height)
        let scaleX = view.frame.size.width / widthOriginal
        let scaleY = view.frame.size.height / heightOriginal
        let minX = CGFloat(artworkItem.x) * scaleX
        let minY = CGFloat(artworkItem.y) * scaleY
        let widthtrimImageView = CGFloat(artworkItem.width) * scaleX
        let heighttrimImageView = CGFloat(artworkItem.height) * scaleY
        trimImageView.frame = CGRect(x: minX, y: minY, width: widthtrimImageView, height: heighttrimImageView)
//        particleImage.size = CGSize(width: 10, height: 10)
        
        trimImageView.sd_setImage(with: artworkItem.artworkItemImageUrl)
        let rotateFrom = CGFloat(artworkItem.rotateFromValue)
        let rotateTo = CGFloat(artworkItem.rotateToValue)

        let scaleFrom = CGFloat(artworkItem.scaleFromValue)
        let scaleTo = CGFloat(artworkItem.scaleToValue)

        let opacityFrom = CGFloat(artworkItem.opacityFromValue)
        let opacityto = CGFloat(artworkItem.opacityToValue)

        AnimateUtilities().allAction(view: trimImageView, rotateFrom: rotateFrom, rotateTo: rotateTo, rotateDuration: artworkItem.rotateAnimateSpeed, scaleFrom: scaleFrom, scaleTo: scaleTo, scaleDuration: artworkItem.scaleAnimateSpeed, autoreverses: true, opacityFrom: opacityFrom, opacityto: opacityto, opacityDuration: artworkItem.opacityAnimateSpeed)
        
        let size = CGFloat(artworkItem.emitterSize) * scaleY
        let speed = CGFloat(artworkItem.emitterSpeed)
        let red = CGFloat(artworkItem.emitterRedValue)
        let green = CGFloat(artworkItem.emitterGreenValue)
        let blue = CGFloat(artworkItem.emitterBlueValue)
        circleWidth = 5 * scaleX
        circleHeight = 5 * scaleY
        
        setEmitter(size: size, speed: speed, red: red, green: green, blue: blue)
    }
    
    func setEmitter(size: CGFloat, speed: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat) {
        /// Set cells
        for _ in 0..<10 {
            let cell = CAEmitterCell()
            cell.birthRate = 2
            cell.lifetime = 2
            cell.lifetimeRange = 1
            cell.scale = 1
            cell.scaleRange = 0.5
            cell.emissionLongitude = CGFloat(0)
            cell.emissionRange = CGFloat(0)
            cell.velocity = CGFloat(speed)
            cell.velocityRange = 25
            cell.color = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0).cgColor
            cell.contents = particleImage.cgImage
            cells.append(cell)
        }
        /// Emitter's position
        let emitterXOffset = trimImageView.center.x
        let emitterYOffset = trimImageView.center.y
        let point = CGPoint(x: emitterXOffset , y: emitterYOffset)
        
        /// Set up CAEmitterLayer
        emitter.emitterPosition = point
        emitter.emitterSize = CGSize(width: CGFloat(size), height: CGFloat(size))
        emitter.emitterShape = .circle
        emitter.emitterMode = .outline
        emitter.emitterCells = cells
        self.view.layer.addSublayer(emitter)
    }
}
