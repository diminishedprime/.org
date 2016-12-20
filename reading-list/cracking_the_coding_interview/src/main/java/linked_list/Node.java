package linked_list;

/**
 * Created by mjhamrick on 12/17/16.
 */
public class Node<T> {
    T data;
    Node<T> next = null;

    Node(T data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "Node{" +
                "data=" + data +
                ", next=" + next +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Node<?> node = (Node<?>) o;

        if (data != null ? !data.equals(node.data) : node.data != null) return false;
        return next != null ? next.equals(node.next) : node.next == null;
    }

    @Override
    public int hashCode() {
        int result = data != null ? data.hashCode() : 0;
        result = 31 * result + (next != null ? next.hashCode() : 0);
        return result;
    }

    void appendToTail(T d) {
        Node<T> end = new Node<T>(d);
        Node n = this;
        while (n.next != null) {
            n = n.next;
        }
        n.next = end;
    }

    public static <T> Node<T> deleteNode(Node<T> head, T d) {
        Node<T> n = head;

        if (n.data.equals(d)) {
            return head.next;
        }

        while (n.next != null) {
            if (n.next.data.equals(d)) {
                n.next = n.next.next;
                return head;
            }
            n = n.next;
        }
        return head;
    }

    public static <T> Node<T> of(T... ts) {
        Node<T> original = new Node<T>(ts[0]);
        for (int i = 1; i < ts.length; i++) {
            original.appendToTail(ts[i]);
        }
        return original;
    }
}
