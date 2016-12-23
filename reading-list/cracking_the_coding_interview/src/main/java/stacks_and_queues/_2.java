package stacks_and_queues;

import java.util.EmptyStackException;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _2 {

    // Stack Min: How would you design a stack which, in addition to
    // push and pop, has a function min which returns the minimum
    // element? Push, pop and min should all operate in 0(1) time.
    // Hints: #27, #59, #78

    public static class MyMinStack<T extends Comparable> {

        private static class StackNode<T extends Comparable> {
            private T min;
            private T data;
            private StackNode<T> next;

            public StackNode(T data, T previousMin) {
                int comparison = data.compareTo(previousMin);
                this.min = comparison < 0 ? data : previousMin;
                this.data = data;
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
            StackNode<T> t = new StackNode<T>(item, min(item));
            t.next = top;
            top = t;
        }

        private T min(T item) {
            return (top == null) ? item : top.min;
        }

        public T peek() {
            if (top == null) throw new EmptyStackException();
            return top.data;
        }

        public boolean isEmpty() {
            return top == null;
        }

    }

}
