//
//  PictureView.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/22.
//

import UIKit
import SnapKit

protocol PictureDelegate {
    func clickMore(_ sender: UIButton)
}

class PictureView: UIView {
    
    var delegate: PictureDelegate?
    
    var image: UIImage?
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.backgroundColor = .white
        return iv
    }()
    
    var closeBtn: UIButton = {
        var b = UIButton()
        b.backgroundColor = .black
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.addTarget(self, action: #selector(clickClose(_:)), for: .touchUpInside)
        b.tintColor = .white
        return b
    }()
    
     init(frame: CGRect, image: UIImage?) {
         self.image = image
            super.init(frame: frame)
            setupLayout()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.backgroundColor = .black
        
        self.addSubview(imageView)
        self.addSubview(closeBtn)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }
        
        imageView.image = self.image
    }
    
    @objc func clickClose(_ sender: UIButton) {
        delegate?.clickMore(sender)
    }

}
