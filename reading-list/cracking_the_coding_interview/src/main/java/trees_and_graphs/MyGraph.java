package trees_and_graphs;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class MyGraph<T> {
    List<MyNode<T>> nodes;

    MyGraph() {
        this.nodes = new ArrayList<>();
    }

    public List<MyNode<T>> getNodes() {
        return nodes;
    }
}
