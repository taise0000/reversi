//
//  ViewController.swift
//  Reversi_app
//
//  Created by 杉浦大盛 on 2021/02/26.
//

//UI生成のライブラリ
import UIKit

//UIViewControllerのサブクラスを生成
class ViewController: UIViewController {

    // BOARDSIZE　で　ボードのサイズを変更できます。
    let BOARDSIZE = 8
    var board = Board()
    var player = Player()

    var player_name = "Random"
    var Stone_count = 0

    // -1: 黒
    //  1: 白
    let User_color = -1
    let Cpu_color = 1

    // ボードはボタンを行列配置して表現される
    var buttonArray: [UIButton] = []

    // board.png, white.png, black.png
    //それぞれの画像をもとにUIImage変数を生成
    let baseBoard = UIImage(named: "board")
    let white = UIImage(named: "white")
    let black = UIImage(named: "black")
    let choice = UIImage(named: "sentaku")

    var resetButton = UIButton()
    var passButton = UIButton()
    var viewStoneCount = UILabel()
    var tarnTime = UILabel()
    var yourTarn = UILabel()

    // オセロ盤を表現するボタン
    class buttonClass: UIButton{
        let x: Int
        let y: Int
        init( x:Int, y:Int, frame: CGRect ) {
            self.x = x
            self.y = y
            super.init(frame:frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("error")
        }
    }

    // ボタンなどを生成
    func createUI(){
        board.start(size: BOARDSIZE)
        var y = 83
        let boxSize = 84 / (BOARDSIZE/4)
        viewStoneCount.frame = CGRect(x: 15, y: 430, width: 330, height: 60)
        yourTarn.frame = CGRect(x: 18, y: 530, width: 330, height: 60)
        viewStoneCount.textAlignment = NSTextAlignment.center
        yourTarn.textAlignment = NSTextAlignment.center
        viewStoneCount.font = UIFont.systemFont(ofSize: 25)
        yourTarn.font = UIFont.systemFont(ofSize: 30)
        self.view.addSubview(viewStoneCount)
        self.view.addSubview(yourTarn)
        for i in 0..<BOARDSIZE{
            var x = 19
            for j in 0..<BOARDSIZE{
                let button: UIButton = buttonClass(
                    x: i,
                    y: j,
                    frame:CGRect(x: x,y: y, width: boxSize,height: boxSize))
                button.addTarget(self, action: #selector(ViewController.pushed), for: .touchUpInside)
                self.view.addSubview(button)
                button.isEnabled = false
                buttonArray.append(button)
                x = x + boxSize + 1
            }
            y = y + boxSize + 1
        }

        resetButton.frame = CGRect(x: 125, y: 675, width: 125, height: 45)
        resetButton.addTarget(self, action: #selector(ViewController.pushResetButton), for: .touchUpInside)
        resetButton.isEnabled = false
        resetButton.isHidden = true
        resetButton.setTitle("RESET", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        resetButton.layer.cornerRadius = 25
        resetButton.layer.shadowOpacity = 0.5
        resetButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(resetButton)

        passButton.frame = CGRect(x: 150, y: 500, width: 80, height: 30)
        passButton.addTarget(self, action: #selector(ViewController.pushPassButton), for: .touchUpInside)
        passButton.isEnabled = false
        passButton.isHidden = true
        passButton.setTitle("Pass", for: .normal)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        passButton.setTitleColor(.white, for: .normal)
        passButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        passButton.layer.cornerRadius = 25
        passButton.layer.shadowOpacity = 0.5
        passButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(passButton)
        drawBoard()
    }

    // passButton を押された時の処理
    @objc func pushPassButton() {
        CpuTurn()
        passButton.isEnabled = false
        passButton.isHidden = true
    }

    // resetButton を押された時の処理
    @objc func pushResetButton() {
        board.reset()
        drawBoard()
        resetButton.isEnabled = false
        resetButton.isHidden = true
        passButton.isEnabled = false
        passButton.isHidden = true
    }

    // ボード盤をタッチされた時の処理
    @objc func pushed(mybtn: buttonClass){
        mybtn.isEnabled = false
        board.put(x: mybtn.x, y: mybtn.y, stone: User_color)
        drawBoard()
        if( board.gameOver() == true ){
            resetButton.isEnabled = true
            resetButton.isHidden = false
        }
        self.CpuTurn()
    }

    // CPU
    func CpuTurn() {
        if( board.available(stone: Cpu_color).count != 0 ){
            let xy = player.play(board: board, stone: Cpu_color)
            board.put(x: xy.0, y: xy.1, stone: Cpu_color)
            drawBoard()
            if( board.gameOver() == true ){
                resetButton.isHidden = false
                resetButton.isEnabled = true
            }
        }
        if( board.gameOver() == true ){
            resetButton.isHidden = false
            resetButton.isEnabled = true
        }
        if( board.available(stone: User_color).count == 0){
            passButton.isHidden = false
            passButton.isEnabled = true
        }
    }

    // 画面にオセロ盤を表示させる
    func drawBoard(){
        let stonecount = board.returnStone()
        viewStoneCount.text = "● User: " + String(stonecount.0) + "     ○ CPU: " + String(stonecount.1)
        yourTarn.text = "あなたの番です"
        var count = 0
        let _board = board.return_board()
        for y in 0..<BOARDSIZE{
            for x in 0..<BOARDSIZE{
                if( _board[y][x] == User_color ){
                    buttonArray[count].setImage(black, for: .normal)
                } else if( _board[y][x] == Cpu_color ){
                    buttonArray[count].setImage(white, for: .normal)
                } else {
                    buttonArray[count].setImage(baseBoard, for: .normal)
                }
                buttonArray[count].isEnabled = false
                count += 1
            }
        }
        let availableList = board.available(stone: User_color)
        for i in 0..<(availableList.count){
            let x = availableList[i][0]
            let y = availableList[i][1]
            buttonArray[x*BOARDSIZE+y].isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createUI()
    }
}

