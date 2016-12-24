package trees_and_graphs;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.function.Function;

public class _3 {

    // List of Depths: Given a binary tree, design an algorithm which creates a
    // linked list of all the nodes at each height (e.g., if you have a tree with
    // height D, you'll have D linked lists).

    // Hints: #107, #123, #135
    public static <T> Map<Integer, LinkedList<T>> levelsOfTree(BinaryNode<T> tree) {
        Map<Integer, LinkedList<T>> data = new HashMap<>();
        inOrderTraversal(tree, new Function<BinaryNode<T>, LinkedList<T>>() {
            @Override
            public LinkedList<T> apply(BinaryNode<T> tBinaryNode) {
                LinkedList<T> list = data.get(tBinaryNode.height) != null ? data.get(tBinaryNode.height) : new LinkedList<T>();
                list.add(tBinaryNode.data);
                data.put(tBinaryNode.height, list);
                return list;
            }
        });
        return data;
    }

    public static <T,K> void inOrderTraversal(BinaryNode<T> tree, Function<BinaryNode<T>, K> visitFn) {
        if (tree.left != null) {
            inOrderTraversal(tree.left, visitFn);
        }
        visitFn.apply(tree);
        if (tree.right != null) {
            inOrderTraversal(tree.right, visitFn);
        }
    }
}
