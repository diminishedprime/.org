package stacks_and_queues;

import java.util.LinkedList;

public class _6 {

    // Animal Shelter: An animal shelter, which holds only dogs and cats,
    // operates on a strictly" first in, first out" basis. People must adopt
    // either the"oldest" (based on arrival time) of all animals at the shelter,
    // or they can select whether they would prefer a dog or a cat (and will
    // receive the oldest animal of that type). They cannot select which specific
    // animal they would like. Create the data structures to maintain this
    // system and implement operations such as enqueue, dequeueAny, dequeueDog,
    // and dequeueCat. You may use the built-in Linked list data structure.

    // Hints: #22, #56, #63

    public static class Animal {
        int order;
    }
    public static class Cat extends Animal {}
    public static class Dog extends Animal {}

    public static class AnimalShelter {
        private int order = 0;
        LinkedList<Dog> dogs;
        LinkedList<Cat> cats;

        Dog dequeueDog() {
            return dogs.pop();
        }

        Cat dequeueCat() {
            return cats.pop();
        }

        Animal dequeueAny() {
            if (dogs.size() == 0) {
                return cats.pop();
            } else if (cats.size() == 0) {
                return dogs.pop();
            } else {
                Animal oldestDog = dogs.peek();
                Animal oldestCat = cats.peek();
                return (oldestDog.order > oldestCat.order) ? cats.pop() : dogs.pop();
            }
        }

        void enqueue(Animal a) {
            a.order = order++;
            if (a instanceof Cat) {
                cats.add((Cat) a);
            } else if (a instanceof Dog) {
                dogs.add((Dog) a);
            } else {
                throw new UnsupportedOperationException();
            }
        }


    }

}
