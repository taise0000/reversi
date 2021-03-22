//
//  player.swift
//  Reversi_app
//
//  Created by 杉浦大盛 on 2021/02/26.
//

import Foundation

class Player {

    func play(board: Board, stone: Int) -> (Int,Int) {
        return Random(available: board.available(stone: stone))
    }

    // 打てるところにランダムで打ちます。
    // swift には random.choice()　みたいなものありますか？
    func Random(available: [[Int]]) -> (Int,Int) {
        let int = Int.random(in: 0..<available.count)
        return (available[int][0], available[int][1])
    }
}
