package trees_and_graphs;

import java.util.Random;

public class _11 {

    // Random Node: You are implementing a binary tree class from scratch which,
    // in addition to insert, find, and delete, has a method getRandomNode()
    // which returns a random node from the tree. All nodes should be equally
    // likely to be chosen. Design and implement an algorithm for getRandomNode,
    // and explain how you would implement the rest of the methods.

    // Hints: #42, #54, #62, #75, #89, #99, #112, #119

    public static class BinaryNode<T extends Comparable<T>> {

        int size = 0;

        T data;

        BinaryNode<T> left;

        BinaryNode<T> right;

        BinaryNode(T data) {
            this.data = data;
        }

        void insert(T t) {
            if (t.compareTo(data) <= 0) {
                if (left == null) {
                    left = new BinaryNode<>(t);
                } else {
                    left.insert(t);
                }
            } else {
                if (right == null) {
                    right = new BinaryNode<>(t);
                } else {
                    right.insert(t);
                }
            }
            size++;
        }

        boolean find(T t) {
            if (t.equals(data)) {
                return true;
            } else if (t.compareTo(data) <= 0) {
                return left != null && left.find(t);
            } else {
                return right != null && right.find(t);
            }
        }

        T getRandomNodeHelper(int randomNumber) {
            int chancesOfLeft = left != null ? left.size : 0;
            int chancesOfRight = right != null ? right.size : 0;
            if (randomNumber == 0) {
                return this.data;
            } else if (randomNumber < chancesOfLeft) {
                return left.getRandomNodeHelper(randomNumber - chancesOfRight - 1);
            } else {
                return right.getRandomNodeHelper(randomNumber - chancesOfLeft - 1);
            }
        }

        T getRandomNode() {
            int chancesOfLeft = left != null ? left.size : 0;
            int chancesOfRight = right != null ? right.size : 0;
            int totalSize = chancesOfLeft + chancesOfRight + 1;
            int randomNumber = new Random().nextInt(totalSize);

            if (randomNumber == 0) {
                return this.data;
            } else if (randomNumber > 0 && randomNumber < chancesOfLeft) {
                return left.getRandomNodeHelper(randomNumber - chancesOfRight - 1);
            } else {
                return right.getRandomNodeHelper(randomNumber - chancesOfLeft - 1);
            }
        }


    }

}
