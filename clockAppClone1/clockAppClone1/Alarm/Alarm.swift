//
//  alarm.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/24/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import MapKit

struct Alarm{
    var title: String
}

class AlarmVC: UIViewController {
    let bottomButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomButton()
        setAlertRequest()
        configureNavBar()
        view.backgroundColor = .white
    }
    
    private func setBottomButton(){
        view.addSubview(bottomButton)
        bottomButton.frame = CGRect(x: view.frame.minX + 50, y: view.frame.minY + 200, width: 300, height: 80)
        bottomButton.setTitle("Click to present", for: .normal)
        bottomButton.backgroundColor = .red
        bottomButton.addTarget(self, action: #selector(presentModalSideVC), for: .touchUpInside)
    }
    
    @objc func presentModalSideVC(){
        self.modalPresentationStyle = .pageSheet
        let vc = ModalSideVC()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func setAlertRequest(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            return
        }
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                print("Unauthorized")
                return
            }
            
            if settings.alertSetting == .enabled{
                print("Enabled")
            }else {
                print("disabled")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "The greeting"
        content.body = "This is my notif cuh"
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(5))
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let randomCategory = UNNotificationCategory(identifier: "RANDOM_NOTIFICATION", actions:[acceptAction, declineAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        // Register the notification type.
        center.setNotificationCategories([randomCategory])
        let textInputContent = UNMutableNotificationContent()
        textInputContent.title = "Text Input Tester"
        textInputContent.subtitle = "Something"
        textInputContent.body = "Trying to test this out."
        content.categoryIdentifier = "RANDOM_NOTIFICATION"
    }
    
    func acceptAction(){
        view.backgroundColor = .cyan
    }
    
    func declineAction(){
        view.backgroundColor = .red
    }
    
    func configureNavBar(){
        navigationItem.title = "Alarm"
        self.navigationController!.navigationBar.tintColor = .systemOrange
        self.navigationController!.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"), style: .plain, target: self, action: #selector(modalViewSelect))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"), style: .plain, target: self, action: #selector(setAlarm))
    }
    
    @objc func modalViewSelect(){
        let vc = modalVC()
        self.modalPresentationStyle = .pageSheet
        vc.view.backgroundColor = .cyan
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func setAlarm(){
        present(UINavigationController(rootViewController: AlarmSetter()), animated: true, completion: nil)
    }
}

class modalVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Welcome."
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(dismissVC))
    }
    
    @objc func dismissVC(){
        navigationController!.dismiss(animated: true, completion: nil)
    }
}

class AlarmSetter: UIViewController{
    let selections = ["Repeat","Label","Sound","Snooze"]
    let CELL_ID = "blah"
    var tableView: UITableView!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavBar()
        configureDatePicker()
        configureTableView()
    }
    func configureNavBar(){
        title = "Add Alarm"
        self.navigationController!.navigationBar.tintColor = .systemOrange
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSetter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
    }
    
    @objc func cancelSetter(){
        dismiss(animated: true, completion: nil)
    }
    
    func configureDatePicker(){
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3))
        view.addSubview(datePicker)
        datePicker.backgroundColor = .white
        datePicker.tintColor = .green
        datePicker.datePickerMode = .time
    }
    func configureTableView(){
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
    }
}
extension AlarmSetter: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = selections[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
}
extension AlarmVC: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
        case "ACCEPT_ACTION":
            print("Accept.")
            acceptAction()
        case "DECELINE ACTION":
            print("Decline.")
            declineAction()
        default:
            print("No actions taken.")
            break
        }
        completionHandler()
    }
}
extension AlarmVC: UIViewControllerTransitioningDelegate{
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
extension AlarmVC: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        // If the view to transition from is this controller's view, the drawer is being presented.
        let isPresentingDrawer = fromView == view
        
        let drawerView = isPresentingDrawer ? toView : fromView

        if isPresentingDrawer {
            // Any presented views must be part of the container view's hierarchy
            transitionContext.containerView.addSubview(drawerView)
        }

        /***** Animation *****/
        
        let drawerSize = CGSize(
            width: UIScreen.main.bounds.size.width * 0.5,
            height: UIScreen.main.bounds.size.height)
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: drawerSize.width * -1, y:0), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        
        drawerView.frame = isPresentingDrawer ? offScreenDrawerFrame : onScreenDrawerFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        // Animate the drawer sliding in and out.
        UIView.animate(withDuration: animationDuration, animations: {
            drawerView.frame = isPresentingDrawer ? onScreenDrawerFrame : offScreenDrawerFrame
        }, completion: { (success) in
            // Cleanup view hierarchy
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }
            
            // IMPORTANT: Notify UIKit that the transition is complete.
            transitionContext.completeTransition(success)
        })
    }
    
    
}
