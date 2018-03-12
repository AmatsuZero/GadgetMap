//
//  SortTest.swift
//  CLSwiftTests
//
//  Created by modao on 2018/3/11.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import XCTest
@testable import AMapAPI

class SortTest: XCTestCase {

    func testBubble() {
        var test = [1,9,5,7,3,21]
        measure {
            test.bubbleSort()
        }
        print(test)
    }

    func testSelection() {
        var arr = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48]
        measure {
             arr.selectionSort()
        }
        print(arr)
    }

    func testInsertion() {
        var arr = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48]
        measure {
             arr.binaryInsertionSort()
        }
        print(arr)
    }

    func testShell() {
        var arr = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48]
        measure {
            arr.shellSort()
        }
        print(arr)
    }

    func testMerge() {
        var arr = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48]
        measure {
            arr.mergeSort()
        }
        print()
    }

    func testQuichSort() {
        var arr = [91,60,96,13,35,65,46,65,10,30,20,31,77,81,22]
        measure {
            arr.quickSort()
        }
        print(arr)
    }

    func testHeapSort() {
        var arr = [91,60,96,13,35,65,46,65,10,30,20,31,77,81,22]
        measure {
            arr.heapSort()
        }
        print(arr)
    }

    func testbucketSort()  {
        var arr = [3, 44, 38, 5, 47, 15, 36, 26, 27, 2, 46, 4, 19, 50, 48]
        measure {
            arr.bucketSort()
        }
        print(arr)
    }

    func testTree() {
        let arr = [91,60,96,13,35,65,46,65,10,30,20,31,77,81,22]
        var root = BinaryNode<Int>(data: arr.first!)
        arr.forEach({ el in
            BinaryNode<Int>.insert(rootNode: &root, value: el)
        })
        print(BinaryNode.nodeCount(root: root))
        print(BinaryNode.depth(root: root))
        BinaryNode.preorderTraverse(root: root) { el in
            print(el.data)
        }
    }
}
