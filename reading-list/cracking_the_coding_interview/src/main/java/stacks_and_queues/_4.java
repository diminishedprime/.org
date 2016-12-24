package stacks_and_queues;

/**
 * Created by mjhamrick on 12/23/16.
 */
public class _4 {
    // Queue via Stacks: Implement a MyQueue class which implements a queue using two stacks.
    // Hints: #98, #114
    public static class MyQueue4<T> {

        private boolean dataInReverseOrder = false;

        private MyStack<T> data;
        private MyStack<T> storage;

        public MyQueue4() {
            data = new MyStack<T>();
            storage = new MyStack<T>();
        }

        public void add(T element) {
            if (dataInReverseOrder) {
                // put storage data back into data into the original order
                while (!storage.isEmpty()) {
                    T temp = storage.pop();
                    data.push(temp);
                }
                dataInReverseOrder = false;
            }
            data.push(element);
        }

        public T remove() {
            T currentElement = null;

            if (dataInReverseOrder) {
                currentElement = storage.pop();
            } else {
                while (!data.isEmpty()) {
                    currentElement = data.pop();
                    // if it is the last element, don't push it back on
                    if (!data.isEmpty()) {
                        storage.push(currentElement);
                    }
                }
                //storage is now in reverse order
                dataInReverseOrder = true;
            }
            return currentElement;
        }

        public T peek() {
            T currentElement = null;

            if (dataInReverseOrder) {
                currentElement = storage.peek();
            } else {
                while (!data.isEmpty()) {
                    currentElement = data.pop();
                    storage.push(currentElement);
                }
                //storage is now in reverse order
                dataInReverseOrder = true;
            }
            return currentElement;
        }

        public boolean isEmpty() {
            return data.isEmpty();
        }
    }
}