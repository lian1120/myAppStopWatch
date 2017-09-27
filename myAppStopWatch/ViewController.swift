//
//  ViewController.swift
//  myAppStopWatch
//
//  Created by 江禮安 on 2017/9/23.
//  Copyright © 2017年 江禮安. All rights reserved.
//
import UIKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var hh: UILabel!
    @IBOutlet weak var mm: UILabel!
    @IBOutlet weak var ss: UILabel!
    @IBOutlet weak var ms: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var h = 0,m = 0,s = 0,n = 0, count = 0, pasue = false
    var a:Timer?,b:Timer?,c:Timer?,d:Timer?
    var timeCount:Array<String> = Array()

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCount.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = timeCount[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.init(red: 0.994, green: 0.882, blue: 0.9993, alpha: 1)
        }else {
            cell.backgroundColor = UIColor.init(red: 0.982, green: 0.969, blue: 0.903, alpha: 1)
        }
        return cell
    }
//    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        
//        return .delete  //設定為可刪除模式
//        
//    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //if editingStyle == .delete {
        
            timeCount.remove(at: indexPath.row)
            //刪除row的第一步是先刪除陣列資料
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //刪除row的第二步是刪除tableView的row，app畫面會刪除掉。
            tableView.reloadData()
        
        
//        }else if editingStyle == .insert {
//            count += 1
//            timeCount.append("\(count)-> \(h):\(m):\(s).\(n)")
//            //先從陣列資料 新增內容
//            tableView.reloadData()
//            //tableView的畫面進行更新
//            let i = IndexPath(item: indexPath.row, section: 0)
//            tableView.scrollToRow(at: i, at: .top, animated: true)
//            //新增多筆row，如果內容超過畫面, 就移動畫面到新的內容
//        }
        
    }
    
    @IBAction func reset(_ sender: Any) {
        //判斷按鈕該執行哪一個事項
        if btn2.currentTitle == "Reset" {
            //清空變數內容
            hh.text! = "00";mm.text! = "00";ss.text! = "00";ms.text! = "00"
            h = 0;m = 0;s = 0;n = 0;count = 0;timeCount.removeAll()
            a?.invalidate();b?.invalidate();c?.invalidate();d?.invalidate();
            tableView.reloadData()
        }else if btn2.currentTitle == "Lap" {
            //記錄每一圈的秒數，資料呈現在tableView
            count += 1
            timeCount.append("\(count)-> \(h):\(m):\(s).\(n)")
            
//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(item: timeCount.count-1, section: 0)], with: .automatic)
//            tableView.endUpdates()
            tableView.reloadData()
            let i = IndexPath(item: count-1, section: 0)
            tableView.scrollToRow(at: i, at: .top, animated: true)
        }
    }
    
    @IBAction func start(_ sender: Any) {
        //判斷按鈕該執行哪一個事項
        if btn1.currentTitle == "Start" {
            //改變按鈕為pasue
            btn1.setTitle("PASUE", for: .normal)
            btn1.setTitleColor(UIColor.green, for: .normal)
            btn2.setTitle("Lap", for: .normal)
            btn2.setTitleColor(UIColor.brown, for: .normal)
            pasue = false
            //建立時分秒毫秒的週期任務
            a = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
                (Timer) in
                self.taskms(timer:Timer)
            }
            b = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
                (Timer) in
                self.taskss(timer:Timer)
            }
            c = Timer.scheduledTimer(withTimeInterval: 60, repeats: true){
                (Timer) in
                self.taskmm(timer:Timer)
            }
            d = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true){
                (Timer) in
                self.taskhh(timer:Timer)
            }
        }else if btn1.currentTitle == "PASUE" {
            //改變按鈕1為Start，按鈕2為Reset
            btn1.setTitle("Start", for: .normal)
            btn1.setTitleColor(UIColor.init(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            btn2.setTitle("Reset", for: .normal)
            btn2.setTitleColor(UIColor.init(red: 0, green: 0.478431, blue: 1, alpha: 1), for: .normal)
            pasue = true  //設定 暫停為true
        }
    }
    func taskms(timer: Timer) {  //毫秒->週期任務
        if pasue == true {  //判斷是否暫停
            timer.invalidate()
            pasue = true
        }else{
            self.n += 1;
            self.ms.text = "\(self.n)"
            if self.n == 999 {self.n = 0}
        }
    }
    func taskss(timer: Timer){  //秒->週期任務
        if pasue == true {
            timer.invalidate()
            pasue = true
        }else{
            self.s += 1
            self.ss.text = "\(self.s)"
            if self.s == 59 {self.s = 0}
        }
    }
    func taskmm(timer: Timer){  //分->週期任務
        if pasue == true {
            timer.invalidate()
            pasue = true
        }else{
            self.m += 1
            self.mm.text = "\(self.m)"
            if self.m == 59 {self.m = 0}
        }
    }
    func taskhh(timer: Timer){  //時->週期任務
        if pasue == true {
            timer.invalidate()
            pasue = true
        }else{
            self.h += 1
            self.hh.text = "\(self.h)"
            if self.h == 23 {self.h = 0}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.isEditing = true  //開啟tableView為可編輯模式
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//        var i = 0
//        queue1.async{
//            repeat {
//                DispatchQueue.main.async {
//                    self.ss.text = "\(i)"
//                }
//                sleep(1)
//                i += 1
//                if i == 4 { i = 0}
//            }while i < 4
//        }

//var s = 0
//queue1.async{
//    repeat {
//        DispatchQueue.main.async {
//            self.ss.text = "\(s)"
//        }
//        sleep(1)
//        s += 1
//        if s == 10 { s = 0}
//    }while s < 10
//}
//var m = 0
//queue2.async{
//    repeat {
//        DispatchQueue.main.async {
//            self.mm.text = "\(m)"
//        }
//        sleep(1)
//        m += 1
//        if m == 4 { m = 0}
//    }while m < 4
//}
//var h = 0
//queue3.async{
//    repeat {
//        DispatchQueue.main.async {
//            self.hh.text = "\(h)"
//        }
//        sleep(1)
//        h += 1
//        if h == 4 { h = 0}
//    }while h < 4
//}
