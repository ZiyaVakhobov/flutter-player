//
//  channelCollectionCell.swift
//  Runner
//
//  Created by Sunnatillo Shavkatov on 21/04/22.
//
import UIKit

class tvCollectionCell: UICollectionViewCell {
    
    var model : String? {
        didSet{
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(label)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    func setupUI(){
        label.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(104)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
