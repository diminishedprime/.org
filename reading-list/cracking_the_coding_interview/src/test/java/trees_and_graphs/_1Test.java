package trees_and_graphs;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _1Test {

    @Test
    public void test() {

        MyGraph<Integer> graph = new MyGraph<Integer>();

        MyNode<Integer> node1 = new MyNode<>(1);
        MyNode<Integer> node2 = new MyNode<>(2);
        MyNode<Integer> node3 = new MyNode<>(3);
        MyNode<Integer> node4 = new MyNode<>(4);
        MyNode<Integer> node5 = new MyNode<>(5);


        node1.getAdjacent().add(node2);
        node2.getAdjacent().add(node3);

        node5.getAdjacent().add(node4);

        graph.getNodes().add(node1);
        graph.getNodes().add(node5);

        assertTrue(_1.routeBetween2NodesBFS(graph, node1, node3));
        assertFalse(_1.routeBetween2NodesBFS(graph, node5, node1));

    }

    @Test
    public void test2() {

        MyGraph<Integer> graph = new MyGraph<Integer>();

        MyNode<Integer> node1 = new MyNode<>(1);
        MyNode<Integer> node2 = new MyNode<>(2);
        MyNode<Integer> node3 = new MyNode<>(3);
        MyNode<Integer> node4 = new MyNode<>(4);
        MyNode<Integer> node5 = new MyNode<>(5);


        node1.getAdjacent().add(node2);
        node2.getAdjacent().add(node3);

        node5.getAdjacent().add(node4);

        graph.getNodes().add(node1);
        graph.getNodes().add(node5);

        assertTrue(_1.routeBetween2NodesDFS(graph, node1, node3));
        assertFalse(_1.routeBetween2NodesDFS(graph, node5, node1));

    }

}
