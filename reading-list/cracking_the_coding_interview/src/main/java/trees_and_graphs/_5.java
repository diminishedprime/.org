package trees_and_graphs;

public class _5 {
    // Validate BST: Implement a function to check if a binary tree is a binary
    // search tree.

    // Hints: #35, #57, #86, #113, #128

    // This works for duplicates
    public static <T extends Comparable<T>> boolean isBSTWithDupes(BinaryNode<T> tree) {
        return isBSTWithDupesHelper(tree, null, null);
    }

    private static <T extends Comparable<T>> boolean isBSTWithDupesHelper(BinaryNode<T> tree, T min, T max) {
        if (tree == null) return true;

        if ((min != null && tree.data.compareTo(min) <= 0) || (max != null && tree.data.compareTo(max) > 0)) {
            return false;
        }
        if (!isBSTWithDupesHelper(tree.left, min, tree.data)) return false;
        if (!isBSTWithDupesHelper(tree.right, tree.data, max)) return false;
        return true;
    }

    // This works if duplicates aren't allowed.
    public static <T extends Comparable<T>> boolean isBinarySearchTreeNoDupes(BinaryNode<T> tree) {
        T previousElement = null;
        return isBSTNoDupesHelper(tree, previousElement);
    }

    private static <T extends Comparable<T>> boolean isBSTNoDupesHelper(BinaryNode<T> tree, T previousElement) {
        if (tree == null) return true;
        if (!isBSTNoDupesHelper(tree.left, previousElement)) return false;
        previousElement = (previousElement == null) ? tree.data : previousElement;
        if (!(tree.data.compareTo(previousElement) >= 0)) return false;
        previousElement = tree.data;
        return isBSTNoDupesHelper(tree.right, previousElement);
    }


}
