//
//  BaseCollectionViewCell.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/28.
//

import UIKit
import SnapKit
import Kingfisher

class BaseCollectionViewCell: UICollectionViewCell, Calculation {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    
    //MARK:- Methods
    
    func setupUI() { }
    func setupConstraints() { }
    
}
