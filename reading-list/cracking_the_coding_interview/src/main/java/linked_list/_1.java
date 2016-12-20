package linked_list;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by mjhamrick on 12/17/16.
 */
public class _1 {
    //Remove Dupes! Write code to remove duplicates from an unsorted linked list.
    // FOLLOW UP
    // How would you solve this problem if a temporary buffer is not allowed? Hints: #9, #40

    public static <T> void dedupe(Node<T> list) {
        Set<T> elementsSOFar = new HashSet<T>();

        Node<T> previous = null;
        while (list != null) {
            if (elementsSOFar.contains(list.data)) {
                previous.next = list.next;
            } else {
                elementsSOFar.add(list.data);
                previous = list;
            }
            list = list.next;
        }
    }


}
