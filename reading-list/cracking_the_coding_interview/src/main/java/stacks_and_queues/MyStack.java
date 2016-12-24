package stacks_and_queues;

import linked_list.MyList;

import java.util.EmptyStackException;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class MyStack<T> {

    @Override
    public String toString() {
        return "{" + top + '}';
    }

    public int size() {
        return (top == null) ? 0 : top.size;
    }

    private static class StackNode<T> {

        @Override
        public String toString() {
            return data + ((next != null) ? ("," + next) : "");
        }

        private T data;
        private StackNode<T> next;
        private int size;

        public StackNode(T data, int size) {
            this.data = data;
            this.size = size;
        }
    }

    private StackNode<T> top;

    public T pop() {
        if (top == null) throw new EmptyStackException();
        T item = top.data;
        top = top.next;
        return item;
    }

    public void push(T item) {
        int size = (top == null) ? 1 : top.size + 1;

        StackNode<T> t = new StackNode<T>(item, size);
        t.next = top;
        top = t;
    }

    public T peek() {
        if (top == null) throw new EmptyStackException();
        return top.data;
    }

    public boolean isEmpty() {
        return top == null;
    }

}
