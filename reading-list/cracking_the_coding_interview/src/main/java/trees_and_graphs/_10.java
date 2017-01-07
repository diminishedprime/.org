package trees_and_graphs;

public class _10 {

    // Check Subtree: T1 and T2 are two very large binary trees, with T1 much
    // bigger than T2. Create an algorithm to determine if T2 is a subtree of
    // T1. A tree T2 is a subtree of T1 if there exists a node n in T1  such that
    // the subtree of n is identical to T2. That is, if you cut off the tree at
    // node n, the two trees would be identical.

    // Hints: #4, #11, #18, #31, #37

    static boolean isSubTreeStringForSomeReason(BinaryNode<Integer> t1, BinaryNode<Integer> t2) {
        StringBuilder s1 = new StringBuilder();
        StringBuilder s2 = new StringBuilder();

        getOrderedString(t1, s1);
        getOrderedString(t2, s2);

        return s1.indexOf(s2.toString()) != -1;

        return false;
    }

    private static void getOrderedString(BinaryNode<Integer> node, StringBuilder sb) {
        if (node == null) {
            sb.append("X");
        } else {
            sb.append(node.data + " ");
            getOrderedString(node.left, sb);
            getOrderedString(node.right, sb);
        }
    }

    static <T> boolean isSubTreeOf(BinaryNode<T> t1, BinaryNode<T> t2) {
        if (t1 == null)
            return false;
        return t1.equals(t2) ||
                isSubTreeOf(t1.left, t2) ||
                isSubTreeOf(t1.right, t2);

    }
}
