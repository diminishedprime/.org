class Vector {

private:
  double* elem;
  int sz;

public:
  Vector(int s)
    : elem(new double[s])
    , sz(s) {
    for (int i = 0; i != s; ++i) {
      elem[i] = 0; // initialize element
    }
  }

  ~Vector() {
    delete[] elem;
  }

  double& operator[](int i) {
    return elem[i];
  }

  int size () const {
    return sz;
  }

};
