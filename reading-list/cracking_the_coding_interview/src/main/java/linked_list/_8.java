package linked_list;

import java.util.HashSet;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _8 {

    // Loop Detection: Given a circular linked list, implement an algorithm that returns the node at the
    // beginning of the loop.
    // DEFINITION
    // Circular linked list: A (corrupt) linked list in which a node's next pointer points to an earlier node, so as to make a loop in the linked list.
    // EXAMPLE
    // Input: A -> B -> C -> D -> E -> C[thesameCasearlier]
    // Output: C
    // Hints: #50, #69, #83, #90
    public static <T> MyList<T> beginningOfLoop(MyList<T> list) {
        MyList<T> slow = list;
        MyList<T> fast = list;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) {
                //collision
                break;
            }
        }
        // there was no collision, no loop.
        if (fast == null || fast.next == null) {
            return null;
        }
        //reset slow to the start of the list
        slow = list;
        while (slow != fast) {
            slow = slow.next;
            fast = fast.next;
        }
        return slow;
    }

}
