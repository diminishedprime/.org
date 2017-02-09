#include <iostream>

using namespace std;

struct Vector {
  int size;
  double* elements;
};

void vector_init(Vector& vector, int size) {
  vector.elements = new double[size];
  vector.size = size;
}

double read_and_sum(int s) {
  Vector v;
  vector_init(v, s);

  for (int i = 0; i !=s; ++i) {
    cin >> v.elements[i];
  }

  double sum = 0;
  for (int i = 0; i != s; ++i) {
    sum += v.elements[i];
  }
  return sum;
}


int main() {
  double sum = read_and_sum(3);
  cout << "The sum was: " << sum;
}
