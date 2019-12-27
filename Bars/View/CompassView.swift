//
//  CompassView.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import UIKit

class CompassView: UIView {
    
    weak var delegate: SegueDelegate?
    
    @objc func buttonTapped(){
       self.delegate?.onBarNameTapped()
    }
    
    lazy var arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage(named: "bottle")
        arrow.translatesAutoresizingMaskIntoConstraints = false
        return arrow
    }()
    
    lazy var barName: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("BarName", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var activity: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.startAnimating()
        activityView.color = .black
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    lazy var nameActivity: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.startAnimating()
        activityView.color = .black
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    lazy var distance: UILabel = {
        let lbl = UILabel()
        lbl.text = "Distance: "
        lbl.textColor = .black
        lbl.isHidden = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(arrow)
        self.addSubview(barName)
        self.addSubview(distance)
        self.addSubview(activity)
        self.addSubview(nameActivity)
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrow.heightAnchor.constraint(equalToConstant: 240.0),
            arrow.widthAnchor.constraint(equalToConstant: 240.0),
            
            barName.topAnchor.constraint(equalTo: arrow.bottomAnchor, constant: 30),
            barName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            distance.topAnchor.constraint(equalTo: barName.bottomAnchor, constant: 20),
            distance.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameActivity.topAnchor.constraint(equalTo: arrow.bottomAnchor, constant: 30),
            nameActivity.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            activity.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activity.topAnchor.constraint(equalTo: barName.bottomAnchor, constant: 20)
        ])
    }
}
