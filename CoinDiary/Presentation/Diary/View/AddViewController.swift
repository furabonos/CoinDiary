//
//  AddViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import UIKit
import SnapKit
import Combine

class AddViewController: BaseViewController {
    
    var dateLabel: UILabel = {
        var l = UILabel()
        l.text = "기록일"
        return l
        
    }()
    
    var dateField: LeftPaddingLabel = {
        var l = LeftPaddingLabel()
        l.text = "\(Date().getToday)"
        l.layer.borderColor = UIColor.gray.cgColor
        l.layer.borderWidth = 0.5
        l.layer.cornerRadius = 10
        return l
    }()
    
    var startLabel: UILabel = {
        var l = UILabel()
        l.text = "시작시드"
        return l
    }()
    
    lazy var startField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    var endLabel: UILabel = {
        var l = UILabel()
        l.text = "종료시드"
        return l
    }()
    
    lazy var endField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    var memoLabel: UILabel = {
        var l = UILabel()
        l.text = "메모"
        return l
    }()
    
    lazy var memoField: UITextView = {
        var tf = UITextView()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    var addBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "photo"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.addTarget(self, action: #selector(getPhoto(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var images: UIImage!
    
    var pictureView = PictureView(frame: .zero, image: nil)
    
    public var viewModel: AddViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    static func create(with viewModel: AddViewModel) -> AddViewController {
        let view = AddViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        //입력할것 시작금액 종료금액 메모 사진 날짜는 자동세팅
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImageView(_:)))
        imageView.addGestureRecognizer(tabGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUI() {
        [dateLabel, dateField, startLabel, startField, endLabel, endField, memoLabel, memoField, addBtn, imageView].forEach { self.view.addSubview($0) }
    }
    
    override func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        dateField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        startLabel.snp.makeConstraints {
            $0.top.equalTo(dateField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        startField.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        endLabel.snp.makeConstraints {
            $0.top.equalTo(startField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        endField.snp.makeConstraints {
            $0.top.equalTo(endLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(endField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        memoField.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        addBtn.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(100)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(50)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(10)
            $0.trailing.equalTo(memoField.snp.trailing)
            $0.width.height.equalTo(60)
        }
    }
    
    @objc func getPhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func clickImageView(_ sender: AnyObject) {
        self.pictureView = PictureView(frame: .zero, image: self.images)
        pictureView.delegate = self
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pictureView)
        pictureView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }

}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.images = image
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddViewController: PictureDelegate {
    func clickMore(_ sender: UIButton) {
        pictureView.removeFromSuperview()
    }
}

