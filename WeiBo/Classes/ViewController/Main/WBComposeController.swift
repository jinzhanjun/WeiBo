//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/9.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBComposeController: UIViewController, UITextViewDelegate {
    /// 导航标题标签
    @IBOutlet var navTitleLabel: UILabel!
    /// 文本视图
    @IBOutlet weak var textView: UITextView!
    /// 工具条距离底边高度
    @IBOutlet weak var toolBarBottomHeight: NSLayoutConstraint!
    /// 返回按钮
    lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var sendBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 55, height: 35))
        button.setTitle("发送", for: .normal)
        button.setTitle("发送", for: .highlighted)
        button.setTitle("发送", for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        button.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        return UIBarButtonItem(customView: button)
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置代理
        textView.delegate = self
        // 设置界面
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 已出现就直接唤起键盘
        textView.becomeFirstResponder()
    }
    
    /// 设置界面
    private func setupUI() {
        // 设置导航条
        setupNavBar()
        // 注册键盘变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillChange(n:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    /// 销毁
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    /// 设置导航条
    private func setupNavBar() {
        // 添加title
        navigationItem.titleView = navTitleLabel
        // 添加取消按钮条目
        navigationItem.leftBarButtonItem = backBarButtonItem
        // 添加发布按钮条目
        navigationItem.rightBarButtonItem = sendBarButtonItem
        
        sendBarButtonItem.isEnabled = false
    }
    
    /// 取消撰写微博
    @objc private func back() {
        /// 正在展现的控制器（也就是自己）消失
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 监听键盘唤醒的通知
    @objc private func keyBoardWillChange(n: NSNotification) {
        guard let userInfo = n.userInfo as? [String: AnyObject],
            let UIKeyboardFrameEnd = userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue,
        let animationDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double
            else { return }

        // 调整工具条的位置
        toolBarBottomHeight.constant = -(view.bounds.height - UIKeyboardFrameEnd.cgRectValue.origin.y)
        // 调整工具条的高度


        UIView.animate(withDuration: TimeInterval(exactly: animationDuration) ?? 0) {
            self.view.layoutSubviews()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendBarButtonItem.isEnabled = textView.hasText
    }
}
