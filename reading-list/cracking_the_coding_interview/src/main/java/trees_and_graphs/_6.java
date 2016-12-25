package trees_and_graphs;

import trees_and_graphs.BinaryNode;

public class _6 {
    // Successor: Write an algorithm to find the "next" node (i.e., in-order
    // successor) of a given node in a binary search tree. You may assume that
    // each node has a link to its parent.

    // Hints: #79, #91
    public static <T> BinaryNode<T> next(BinaryNode<T> node) {
        if (node == null) return null;

        if (node.right != null) {
            return leftMostNode(node.right);
        } else {
            BinaryNode<T> q = node;
            BinaryNode<T> x = q.parent;
            // go up until we're on left instead of right
            while (x != null && x.left != q) {
                q = x;
                x = x.parent;
            }
            return x;
        }
    }

    private static <T> BinaryNode<T> leftMostNode(BinaryNode<T> node) {
        if (node.left != null) {
            return leftMostNode(node.left);
        } else {
            return node;
        }
    }
}
