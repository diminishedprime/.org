package trees_and_graphs;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

public class _4 {

    // Check Balanced: Implement a function to check if a binary tree is
    // balanced. For the purposes of this question, a balanced tree is de ned to
    // be a tree such that the heights of the two subtrees of any node never
    // differ by more than one.

    // Hints: #27, #33, #49, #105, #124
    public static <T> boolean isBalanced(BinaryNode<T> tree) {
        List<Boolean> result = new ArrayList<>();
        tree.inOrderTraversalNodes(new Function<BinaryNode<T>, Boolean>() {
            @Override
            public Boolean apply(BinaryNode<T> tBinaryNode) {
                boolean val = Math.abs(
                        (tBinaryNode.left != null ? tBinaryNode.left.height : 0) -
                        (tBinaryNode.right != null ? tBinaryNode.right.height : 0)) > 1;
                result.add(val);
                return val;
            }
        });
        for (boolean bool : result) {
            if (bool) {
                return false;
            }
        }
        return true;
    }
}
