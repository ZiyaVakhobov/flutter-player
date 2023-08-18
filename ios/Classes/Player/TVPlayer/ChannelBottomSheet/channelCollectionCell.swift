//
//  channelCollectionCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit
import SnapKit
import SDWebImage

class channelCollectionCell: UICollectionViewCell {
    
    var model : Channel? {
        didSet{
        }
    }
    
    lazy var channelImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image.png")
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    lazy var channelName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(channelImage)
        contentView.addSubview(channelName)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    func setupUI(){
        channelImage.snp.makeConstraints { make in
            make.height.equalTo(104)
            make.width.equalTo(104)
        }

        channelName.snp.makeConstraints { make in
                make.top.equalTo(channelImage.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(8)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stringToFloat(value : String) -> Float {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: value)
        let numberFloatValue = number?.floatValue
        return numberFloatValue ?? 0.0
    }
    
}
