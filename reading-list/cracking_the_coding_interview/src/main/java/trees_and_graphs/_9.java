package trees_and_graphs;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class _9 {
    // BST Sequences: A binary search tree was created by traversing through an
    // array from left to right and inserting each element. Given a binary
    // search tree with distinct elements, print all possible arrays that could
    // have led to this tree.
    // EXAMPLE  2
    //         / \
    //        1   3

    // Output: {2, 1, 3}, {2, 3, 1}
    // Hints: #39, #48, #66, #82
    public static List<LinkedList<Integer>> allSequences(BinaryNode<Integer> node) {

        List<LinkedList<Integer>> result = new ArrayList<>();

        if (node == null) {
            result.add(new LinkedList<>());
            return result;
        }
        LinkedList<Integer> prefix = new LinkedList<>();
        prefix.add(node.data);

        // recur on left and right subtrees
        List<LinkedList<Integer>> leftSeq = allSequences(node.left);
        List<LinkedList<Integer>> rightSeq = allSequences(node.right);

        for (LinkedList<Integer> left : leftSeq) {
            for (LinkedList<Integer> right : rightSeq) {
                List<LinkedList<Integer>> weaved = new ArrayList<>();
                weaveLists(left, right, weaved, prefix);
                result.addAll(weaved);
            }
        }
        return result;
    }

    private static void weaveLists(LinkedList<Integer> first, LinkedList<Integer> second,
                                   List<LinkedList<Integer>> results, LinkedList<Integer> prefix) {
        if (first.size() == 0 || second.size() == 0) {
            LinkedList<Integer> result = (LinkedList<Integer>) prefix.clone();
            result.addAll(first);
            result.addAll(second);
            results.add(result);
            return;
        }

        Integer headFirst = first.removeFirst();
        prefix.addLast(headFirst);
        weaveLists(first, second, results, prefix);
        prefix.removeLast();
        first.addFirst(headFirst);

        Integer headSecond = second.removeFirst();
        prefix.addLast(headSecond);
        weaveLists(first, second, results, prefix);
        prefix.removeLast();
        second.addFirst(headSecond);
    }

}
