package trees_and_graphs;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class BinaryNode<T> {

    public T data;
    public int height;
    public BinaryNode<T> left;
    public BinaryNode<T> right;

    private void print(StringBuilder out, String prefix, boolean isTail) {
        out.append(prefix + (isTail ? "└── " : "├── ") + data + "\n");
        List<BinaryNode<T>> children = new ArrayList<BinaryNode<T>>();
        if (right != null) {
            children.add(right);
        }
        if (left != null) {
            children.add(left);
        }
        for (int i = 0; i < children.size() - 1; i++) {
            children.get(i).print(out, prefix + (isTail ? "    " : "│   "), false);
        }
        if (children.size() > 0) {
            children.get(children.size() - 1)
                    .print(out, prefix + (isTail ?"    " : "│   "), true);
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        print(sb, "", true);
        return sb.toString();
    }

    public static <T> BinaryNode<T> leafOf(T t) {
        return new BinaryNode<T>(null, t, null);
    }

    public static <T> BinaryNode<T> treeOf(BinaryNode<T> left, T data, BinaryNode<T> right) {
        return new BinaryNode<T>(left, data, right);
    }

    private BinaryNode() {}

    private BinaryNode(BinaryNode<T> left, T data, BinaryNode<T> right){
        this.left = left;
        this.data = data;
        this.right = right;
        this.height = Math.max(
                (left != null) ? left.height : 0,
                (right != null) ? right.height :0
        ) + 1;
    }

    public boolean isLeaf() {
        return left != null && right != null;
    }


    public <K> BinaryNode<K> inOrderTraversalNodes(Function<BinaryNode<T>, K> visitFn) {
        BinaryNode<K> newNode = new BinaryNode<K>();
        newNode.left = (left != null) ? left.inOrderTraversalNodes(visitFn) : null;
        newNode.data = (data != null) ? visitFn.apply(this) : null;
        newNode.right = (right != null) ? right.inOrderTraversalNodes(visitFn) : null;
        return newNode;
    }

    public <K> BinaryNode<K> inOrderTraversal(Function<T, K> visitFn) {
        BinaryNode<K> newNode = new BinaryNode<K>();
        newNode.left = (left != null) ? left.inOrderTraversal(visitFn) : null;
        newNode.data = (data != null) ? visitFn.apply(data) : null;
        newNode.right = (right != null) ? right.inOrderTraversal(visitFn) : null;
        return newNode;
    }

    public <K> BinaryNode<K> preOrderTraversal(Function<T, K> visitFn) {
        BinaryNode<K> newNode = new BinaryNode<K>();
        newNode.data = (data != null) ? visitFn.apply(data) : null;
        newNode.left = (left != null) ? left.inOrderTraversal(visitFn) : null;
        newNode.data = (data != null) ? visitFn.apply(data) : null;
        return newNode;
    }

    public <K> BinaryNode<K> postOrderTraversal(Function<T, K> visitFn) {
        BinaryNode<K> newNode = new BinaryNode<K>();
        newNode.left = (left != null) ? left.inOrderTraversal(visitFn) : null;
        newNode.data = (data != null) ? visitFn.apply(data) : null;
        newNode.data = (data != null) ? visitFn.apply(data) : null;
        return newNode;
    }


}
