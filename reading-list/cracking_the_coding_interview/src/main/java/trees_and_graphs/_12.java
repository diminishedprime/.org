package trees_and_graphs;

import java.util.HashMap;
import java.util.Map;

public class _12 {

    // Paths with Sum: You are given a binary tree in which each node contains
    // an integer value (which might be positive or negative). Design an
    // algorithm to count the number of paths that sum to a given value. The
    // path does not need to start or end at the root or a leaf, but it must go
    // downwards (traveling only from parent nodes to child nodes).

    // Hints: #6, #14, #52, #68, #77, #87, #94, #103, #108, #115

    public static int numPathsToSumN(BinaryNode<Integer> tree, int requestedSum) {
        return numPathsToSumN(tree, requestedSum, 0, new HashMap<>());
    }

    private static int numPathsToSumN(BinaryNode<Integer> tree, int targetSum, int runningSum, Map<Integer, Integer> pathCount) {
        if (tree == null) {
            return 0;
        }
        /* Count paths with sum ending at the current node */
        runningSum += tree.data;
        int sum = runningSum - targetSum;
        int totalPaths = pathCount.getOrDefault(sum, 0);

        // if runningSum == targetSum, then one additonal path starts at root.
        // Add this path
        if (runningSum == targetSum) {
            totalPaths++;
        }

        incrementHashTable(pathCount, runningSum, 1);
        totalPaths += numPathsToSumN(tree.left, targetSum, runningSum, pathCount);
        totalPaths += numPathsToSumN(tree.right, targetSum, runningSum, pathCount);
        incrementHashTable(pathCount, runningSum, -1);

        return totalPaths;
    }

    private static void incrementHashTable(Map<Integer, Integer> pathCount, int key, int delta) {
        int newCount = pathCount.getOrDefault(key, 0) + delta;
        if (newCount == 0) {
            pathCount.remove(key);
        } else {
            pathCount.put(key, newCount);
        }
    }


    public static int numPathsToSumNLogN(BinaryNode<Integer> tree, int requestedSum) {
        if (tree == null) {
            return 0;
        }
        int pathsFromRoot = numPathsToSumHelper(tree, requestedSum, 0);
        int pathsOnLeft = numPathsToSumNLogN(tree.left, requestedSum);
        int pathsOnRight = numPathsToSumNLogN(tree.right, requestedSum);
        return pathsFromRoot + pathsOnLeft + pathsOnRight;

    }

    private static Integer numPathsToSumHelper(BinaryNode<Integer> tree, int requestedSum, int currentSum) {
        if (tree == null) {
            return 0;
        }

        currentSum += tree.data;

        int totalPaths = 0;

        if (currentSum == requestedSum) {
            totalPaths++;
        }

        totalPaths += numPathsToSumHelper(tree.left, requestedSum, currentSum);
        totalPaths += numPathsToSumHelper(tree.right, requestedSum, currentSum);
        return totalPaths;
    }

}
