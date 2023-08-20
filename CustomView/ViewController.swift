//
//  ViewController.swift
//  CustomView
//
//  Created by andy on 2023/7/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let s = UIButton()
        s.center = view.center
        s.backgroundColor = UIColor.red
        s.frame = CGRect.init(x: 100, y: 100, width: 50, height: 50)
        s.addTarget(self, action: #selector(showCustomPopup(_ :)), for: .touchDown)
        view.addSubview(s)
    }
 
    @objc func showCustomPopup(_ sender: UIButton) {

        let customPopupVC = CustomPopupViewController()
        customPopupVC.modalPresentationStyle = .overFullScreen // 设置弹窗以全屏形式显示
        customPopupVC.modalTransitionStyle = .crossDissolve // 设置弹窗显示的过渡效果
    
        customPopupVC.addAction("确定") { _ in
            print("确定")
        }
        
        let view = UILabel()
        view.backgroundColor = UIColor.orange
        view.numberOfLines = 0
        view.sizeToFit()
        view.text = "- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -- 你好啊 -"
        view.textAlignment = .center
        customPopupVC.addCustomSubview(view, topOffset: 15)
        
        customPopupVC.addAction("取消") { _ in
            print("取消")
        }
        
        customPopupVC.addAction("知道了") { _ in
            print("知道了")
        }

        present(customPopupVC, animated: true, completion: nil)
        
        let btn1 = UIButton()
        btn1.backgroundColor = UIColor.orange
        btn1.setTitle("知道了1", for: .normal)
        customPopupVC.addCustomSubview(btn1, topOffset: 15, height: 48)
        
        let btn2 = UIButton()
        btn2.backgroundColor = UIColor.orange
        btn2.setTitle("知道了1", for: .normal)
        btn2.frame = CGRect(x: 230, y: 20, width: 50, height: 50)
        customPopupVC.addCustomSubview(btn2, frame: btn2.frame)
    }

}


class CustomPopupViewController: UIViewController {
    private let defaultWidth: CGFloat = 295
    typealias Closure = (UIButton) -> (Void)
    private lazy var closureDictionary = [UIButton: Closure]()
    private lazy var popupView = UIView()
    private var lastView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        popupView.layer.cornerRadius = 10
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = UIColor.black
        view.addSubview(popupView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if popupView.subviews.count > 0 {
            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: defaultWidth),
                popupView.topAnchor.constraint(equalTo: popupView.subviews.first!.topAnchor, constant: -15),
                popupView.bottomAnchor.constraint(equalTo: popupView.subviews.last!.bottomAnchor,constant: 15)
            ])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view, view != popupView {
            self.dismiss(animated: true)
        }
    }
    
    @discardableResult
    func addAction(_ title: String,
                   topOffset: CGFloat = 15,
                   height: CGFloat = 48,
                   closure: @escaping Closure) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = UIColor.orange
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(clicked(_ :)), for: .touchUpInside)
        closureDictionary[btn] = closure
        addCustomSubview(btn, topOffset: topOffset, height: height)
        return btn
    }

    func addCustomSubview(_ view: UIView,
                          topOffset: CGFloat = 15,
                          height: CGFloat? = nil) {
        let rect = CGRect(x: 0, y: topOffset, width: defaultWidth, height: height ?? 0)
        addCustomSubview(view, frame: rect)
    }
    
    func addCustomSubview(_ view: UIView,
                          frame: CGRect) {
        view.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(view)
        if frame.height == 0 {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: (lastView == nil) ? popupView.topAnchor:self.lastView!.bottomAnchor, constant: frame.minY),
                view.leftAnchor.constraint(equalTo: popupView.leftAnchor, constant: frame.minX),
                view.widthAnchor.constraint(equalToConstant: frame.width),
            ])
        } else {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: (lastView == nil) ? popupView.topAnchor:self.lastView!.bottomAnchor, constant: frame.minY),
                view.leftAnchor.constraint(equalTo: popupView.leftAnchor, constant: frame.minX),
                view.widthAnchor.constraint(equalToConstant: frame.width),
                view.heightAnchor.constraint(equalToConstant: frame.height),
            ])
        }
        lastView = view
    }
    
    @objc private func clicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.closureDictionary[sender]?(sender)
        }
    }
}
