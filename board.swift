//
//  board.swift
//  Reversi_app
//
//  Created by 杉浦大盛 on 2021/02/26.
//

import Foundation

class Board{

    var SIZE: Int = 0
    let DIRECTIONS_XY = [[-1, -1], [+0, -1], [+1, -1],
                         [-1, +0],           [+1, +0],
                         [-1, +1], [+0, +1], [+1, +1]]
    let BLACK = -1
    let WHITE = 1
    let BLANK = 0
    var square:[[Int]] = []

    // オセロを開始する際に呼ばれ、オセロ盤を初期化する
    func start(size: Int){
        self.SIZE = size
        let center = size / 2
        for _ in 0..<self.SIZE{
            var array:[Int] = []
            for _ in 0..<self.SIZE{
                array += [BLANK]
            }
            square += [array]
        }
        square[center-1][center-1] = self.WHITE
        square[center-1][center] = self.BLACK
        square[center][center-1] = self.BLACK
        square[center][center] = self.WHITE
    }

    // 盤上にある石の個数を返す
    func returnStone() -> (Int,Int) {
        var black = 0
        var white = 0
        var blank = 0
        for y in 0..<SIZE{
            for x in 0..<SIZE{
                switch square[y][x]{
                case BLACK:
                    black += 1
                case WHITE:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        return (black, white)
    }

    // 対戦終了時もう一度対戦する際にボード板をリセットする
    func reset(){
        var _square:[[Int]] = []
        let size = SIZE
        let center = size / 2
        for _ in 0..<SIZE{
            var array:[Int] = []
            for _ in 0..<SIZE{
                array += [BLANK]
            }
            _square += [array]
        }
        _square[center-1][center-1] = self.WHITE
        _square[center-1][center] = self.BLACK
        _square[center][center-1] = self.BLACK
        _square[center][center] = self.WHITE
        square = _square
    }

    // ボード盤を返す
    func return_board() -> [[Int]]{
        return square
    }

    // 呼ばれた段階で Game Over　であるかどうかを判定する
    func gameOver() -> Bool {
        var black = 0
        var white = 0
        var blank = 0
        for y in 0..<SIZE{
            for x in 0..<SIZE{
                switch square[y][x]{
                case BLACK:
                    black += 1
                case WHITE:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        if( blank == 0 || black == 0 || white == 0 ){
            return true
        }
        if( self.available(stone: BLACK).count == 0 && self.available(stone: WHITE).count == 0){
            return true
        }
        return false
    }

    func is_available( x: Int, y:Int, stone: Int) -> Bool {
        if ( square[x][y] != BLANK ){
            return false
        }
        for i in 0..<8 {
            let dx = DIRECTIONS_XY[i][0]
            let dy = DIRECTIONS_XY[i][1]
            if( self.count_reversible(x: x, y: y, dx: dx, dy: dy, stone: stone) > 0 ){
                return true
            }
        }
        return false
    }

    // 引数で与えられた石の次に打てる場所を返す
    func available(stone: Int) -> [[Int]]{
        var return_array:[[Int]] = []
        for x in 0..<SIZE{
            for y in 0..<SIZE{
                if( self.is_available( x: x, y: y, stone: stone) ){
                    return_array += [[x,y]]
                }
            }
        }
        return return_array
    }

    // ボードに石を置く
    func put( x: Int, y:Int, stone: Int){
        square[x][y] = stone
        for i in 0..<8 {
            let dx = DIRECTIONS_XY[i][0]
            let dy = DIRECTIONS_XY[i][1]
            let n = self.count_reversible( x: x, y: y, dx: dx, dy: dy, stone: stone)
            for j in 1..<(n+1){
                square[x + j * dx][y + j * dy] = stone
            }
        }
    }

    func count_reversible( x: Int, y: Int, dx: Int, dy: Int, stone: Int) -> Int {
        var _x = x
        var _y = y
        for i in 0..<SIZE{
            _x = _x + dx
            _y = _y + dy
            // 0 <= x < 4 : can't write <- Annoying!!!!
            if !( 0 <= _x && _x < SIZE && 0 <= _y && _y < SIZE ){
                return 0
            }
            if (square[_x][_y] == BLANK){
                return 0
            }
            if (square[_x][_y] == stone){
                return i
            }
        }
        return 0
    }
}
