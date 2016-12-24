package trees_and_graphs;

import java.util.LinkedList;
import java.util.function.Predicate;

public class _1 {
    // Route Between Nodes: Given a directed graph, design an algorithm to find
    // out whether there is a route between two nodes.

    // Hints: #127

    public static <T> boolean routeBetween2NodesDFS(MyGraph<T> graph, MyNode<T> start, MyNode<T> end) {
        if (start == end) return true;

        return dfs(start, new Predicate<MyNode<T>>() {
            @Override
            public boolean test(MyNode<T> t) {
                return t == end;
            }
        });
    }

    public static <T> boolean dfs(MyNode<T> node, Predicate<MyNode<T>> pred) {
        for (MyNode<T> n : node.getAdjacent()) {
            if (n.getState() == State.Unvisited) {
                n.setState(State.Visiting);
                boolean wasFound = dfs(n, pred);
                if (wasFound) {
                    return true;
                }
            }
        }
        return pred.test(node);

    }

    // using breadth first search
    public static <T> boolean routeBetween2NodesBFS(MyGraph<T> graph, MyNode<T> start, MyNode<T> end) {
        if (start == end) return true;
        LinkedList<MyNode<T>> queue = new LinkedList<>();
        queue.add(start);
        while (!queue.isEmpty()) {
            MyNode<T> u = queue.removeFirst();
            if (u != null) {
                for (MyNode<T> node : u.getAdjacent()) {
                    if (node.getState() == State.Unvisited) {
                        if (node == end) {
                            return true;
                        } else {
                            node.setState(State.Visiting);
                            queue.add(node);
                        }
                    }
                }

            }
        }
        return false;
    }
}
