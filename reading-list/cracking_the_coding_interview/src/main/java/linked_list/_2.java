package linked_list;

import javafx.util.Pair;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _2 {
    // Return Kth to Last: Implement an algorithm to find the kth
    // to last element of a singly linked list.
    // Hints: #8, #25, #41, #67, #126

    public static<T> T kth_to_last_iter(Node<T> list, int kth) {
        // use 2 pointers
        Node<T> p1 = list;
        Node<T> p2 = list;

        // move p1 to the kth position
        for (int i = 0; i < kth; i++) {
            // if p1 ends up being null, that means that there aren't enough elements.
            if (p1 == null) {
                // We would probably want proper error handling here.
                return null;
            } else {
                p1 = p1.next;
            }
        }
        // now the pointers are k apart. If we move p2 with p1 until p1 is
        // null, we are k away from the end of the list
        while (p1 != null) {
            p1 = p1.next;
            p2 = p2.next;
        }
        return p2.data;
    }

    public static <T> T kth_to_last(Node<T> list, int kth) {
        // Ask what we need to do if k is bigger than the size of the list

        // if the linked list size is known, we'd just find the (length-kth) element.
        // We're going to assume that this isn't what the interviewer would want.

        Node<T> answer = kth_to_last_helper(list, kth, new Index());
        return answer.data;
    }

    public static class Index {
        public int value = 0;
    }

    private static <T> Node<T> kth_to_last_helper(Node<T> list, int kth, Index i) {
        if (list == null) {
            return null;
        } else {
            Node<T> node = kth_to_last_helper(list.next, kth, i);
            i.value++;
            if (i.value == kth) {
                return list;
            } else {
                return node;
            }
        }

    }
}
