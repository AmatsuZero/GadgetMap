//
//  BinaryTree.swift
//  CLSwift
//
//  Created by modao on 2018/3/11.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

class BinaryNode<T: Comparable> {
    var left: BinaryNode<T>?
    var right: BinaryNode<T>?
    var parent: BinaryNode<T>?
    let data: T

    init(data: T) {
        self.data = data
    }

    /// 将一个数插入二叉树中
    class func insert<T: Comparable>(rootNode:inout BinaryNode<T>, value: T) {
        if rootNode.data > value {
            //当前结点的值比value大，则成为其左子结点
            if rootNode.left != nil {//看这个结点的左子结点是否存在，如果存在
                rootNode = rootNode.left!
                insert(rootNode: &rootNode, value: value)
            } else {//不存在
                let newNode = BinaryNode<T>(data: value)
                newNode.parent = rootNode
                rootNode.left = newNode
            }
        } else {
            //当前结点的值比value小，则成为其右子结点
            if rootNode.right != nil {//看这个结点的右子结点是否存在，如果存在
                rootNode = rootNode.right!
                insert(rootNode: &rootNode, value: value)
            } else {//不存在
                let newNode = BinaryNode<T>(data: value)
                newNode.parent = rootNode
                rootNode.right = newNode
            }
        }
    }

    /// 二叉树节点个数
    class func nodeCount(root: BinaryNode?) -> Int {
        guard let pRoot = root else { return 0 }
        return nodeCount(root: pRoot.left) + nodeCount(root: root?.right) + 1
    }

    class func depth(root: BinaryNode?) -> Int {
        guard let pRoot = root else { return 0 }
        let leftDepth = depth(root: pRoot.left)
        let rightDepth = depth(root: pRoot.right)
        return max(leftDepth, rightDepth) + 1
    }

    class func preorderTraverse(root:BinaryNode?, callBack: (BinaryNode) -> Void) {
        guard let pRoot = root else {
            return
        }
        callBack(pRoot)
        preorderTraverse(root: pRoot.left, callBack: callBack)
        preorderTraverse(root: pRoot.right, callBack: callBack)
    }
}

extension Array {

}
