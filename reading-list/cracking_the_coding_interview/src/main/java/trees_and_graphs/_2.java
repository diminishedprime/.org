package trees_and_graphs;

public class _2 {
    // Minimal Tree: Given a sorted (increasing order) array with unique integer
    // elements, write an algorithm to create a binary search tree with minimal
    // height.

    // Hints: #19,#73,#116
    public static <T> BinaryNode<T> bstFromSortedArray(T[] array) {
        return bstHelper(array, 0, array.length);
    }

    private static <T> BinaryNode<T> bstHelper(T[] array, int from, int to) {
        if (to <= from) {
            return null;
        } else {
            int middleIndex = (from + to) / 2;
            BinaryNode<T> left = bstHelper(array, from, middleIndex);
            BinaryNode<T> right = bstHelper(array, middleIndex + 1, to);
            return BinaryNode.treeOf(left, array[middleIndex], right);
        }
    }

}
