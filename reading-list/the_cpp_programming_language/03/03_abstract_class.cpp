#include <iostream>
#include "03_vector_with_destructor.cpp"

using namespace std;

class Container {
public:
  virtual double& operator[](int) = 0;
  virtual int size() const = 0;
  virtual ~Container(){}
};

void use(Container& c) {
  const int size = c.size();

  for (int i = 0; i!=size; ++i) {
    cout << c[i] << '\n';
  }
}

class Vector_container : public Container {
  Vector v;

public:
  Vector_container(int s)
    : v(s){
  }
  ~Vector_container() {}

  double& operator[](int i) {
    return v[i];
  }

  int size() const {
    return v.size();
  }

};


int main() {
  cout << "hi";
}
