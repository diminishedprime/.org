package linked_list;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _3 {
    // Delete Middle Node: Implement an algorithm to delete a node in the middle
    // (i.e., any node but the first and last node, not necessarily the exact middle)
    // of a singly linked list, given only access to that node.
    // EXAMPLE
    // Input: the node c from the linked list a->b->c->d->e->f
    // Result: nothing is returned, but the new linked list looks like a->b->d->e->f
    // Hints: #72

    public static <T> void delete_middle_node(Node<T> list) {
        if (list == null || list.next == null) {
            throw new RuntimeException("Handle me!");
        } else {
            Node<T> next = list.next;
            list.data = next.data;
            list.next = next.next;
        }
    }

}
