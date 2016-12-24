package trees_and_graphs;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class MyNode<T> {
    T data;
    List<MyNode<T>> adjacent;
    private State state = State.Unvisited;

    MyNode(T data) {
        this.data = data;
        adjacent = new ArrayList<>();
    }

    public void setState(State state) {
        this.state = state;
    }

    public List<MyNode<T>> getAdjacent() {
        return adjacent;
    }

    public State getState() {
        return state;
    }
}
