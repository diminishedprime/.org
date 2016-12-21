package linked_list;

import javafx.util.Pair;

import java.util.Objects;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _7 {

    // Intersection: Given two (singly) linked lists, determine if the two
    // lists intersect. Return the intersecting node. Note that the
    // intersection is defined based on reference, not value. That is, if the
    // kth node of the first linked list is the exact same node (by reference)
    // as the jth node of the second linked list, then they are intersecting.
    // Hints: #20, #45, #55, #65, #76, #93, #111, #120, #129

    public static <T> MyList<T> intersect(MyList<T> a, MyList<T> b) {
        if (a == null || b == null) return null;

        Pair<MyList<T>, Integer> aTailAndSize = getTailAndSize(a);
        Pair<MyList<T>, Integer> bTailAndSize = getTailAndSize(b);

        int bLength = bTailAndSize.getValue();
        int aLength = aTailAndSize.getValue();

        if (aTailAndSize.getKey() != bTailAndSize.getKey()) {
            return null;
        } else {
            MyList<T> shorterRunner = (aLength < bLength) ? a : b;
            MyList<T> longerRunner = (aLength < bLength) ? b : a;
            int steps = Math.abs(aLength - bLength);
            for (int i = 0; i < steps; i++) {
                longerRunner = longerRunner.next;
            }
            while (shorterRunner != longerRunner) {
                shorterRunner = shorterRunner.next;
                longerRunner = longerRunner.next;
            }
            return shorterRunner;
        }

    }

    private static <T> Pair<MyList<T>, Integer> getTailAndSize(MyList<T> a) {
        MyList<T> head = a;
        int length = 1;
        while (head.next != null) {
            length ++;
            head = head.next;
        }
        return new Pair<>(head, length);
    }
}
