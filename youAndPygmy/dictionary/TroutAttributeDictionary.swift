//
//  TroutAttributeDictionary.swift
//  youAndPygmy
//
//  Created by tomonori takada on 2018/03/08.
//  Copyright © 2018年 tomonori takada. All rights reserved.
//

import Foundation

class TroutAttributeDictionary{
    static func get(key:String)->BattleChipData{
        switch key {
        case "grass":return BattleChipData(attribute:.grass,terrain:"grass",name:"草原")
        default:print("不正な地形名(TroutAttributeDictionary)→",key)
        }
        return BattleChipData(attribute:.grass,terrain:"",name:"不正な地形")
    }
}
struct BattleChipData{
    let attribute:TroutAttribute//属性
    let terrain:String//地形名のキー
    let name:String//地形名
}
struct Mobility{
    let mov:Double//移動力
    let grass:Double//草原
    let sand:Double//砂地
    let water:Double//水路
    let magma:Double//溶岩
    let snow:Double//雪原
    let ice:Double//氷上
    let air:Double//空中
    func get(key:String)->Double{
        switch key {
        case "move":fallthrough
        case "mov":return mov
        case "grass":return grass
        case "sand":return sand
        case "water":return water
        case "magma":return magma
        case "snow":return snow
        case "ice":return ice
        case "air":return air
        default:print("不正な地形属性名",key)
        }
        return -1
    }
    func get(key:TroutAttribute)->Double{
        switch key {
        case .grass:return grass
        case .sand:return sand
        case .water:return water
        case .magma:return magma
        case .snow:return snow
        case .ice:return ice
        case .air:return air
        }
    }
}
enum TroutAttribute{
    case grass
    case sand
    case water
    case magma
    case snow
    case ice
    case air
    func getName()->String{
        switch self {
        case .grass:return "草原"
        case .sand:return "砂地"
        case .water:return "水路"
        case .magma:return "溶岩"
        case .snow:return "雪原"
        case .ice:return "氷上"
        case .air:return "空中"
        }
    }
}
