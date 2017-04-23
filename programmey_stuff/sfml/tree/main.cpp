#include <SFML/Audio.hpp>
#include <SFML/Graphics.hpp>
#include <iostream>
#include <cmath>

using namespace sf;
using namespace std;

const float GOLDEN_BABBY = 1.61803398875 - 1;
const float WIDTH_FRACTION = GOLDEN_BABBY;
const float LENGTH_FRACTION = GOLDEN_BABBY;
const int NUM_LEAVES = 10;
const int LEAF_SIZE = 10;
const int WINDOW_WIDTH = 1800;
const int WINDOW_HEIGHT = 1200;
const int NUMBER_OF_TREES = 1;
const float BRANCH_WIDTH = 20;
const float BRANCH_LENGTH = 120;
const float INITIAL_ANGLE = 180;
const int NUMBER_OF_GENERATIONS = 5;

int randMaybeNeg(int max) {
  auto delta = (max * 2) + 1;
  return -max + (rand() % delta);
}

class Leaf {
public:
  Vector2f originalPosition;
  CircleShape triangle;

  ~Leaf() {
  }
  void draw(RenderWindow& window) {
    togglePosition();
    window.draw(triangle);
  }
  void togglePosition() {
    auto previousPosition = triangle.getPosition();
    auto newPosition = Vector2f(previousPosition.x + randMaybeNeg(2), previousPosition.y + randMaybeNeg(2));
    if (abs(previousPosition.x - originalPosition.x) > 50
        || abs(previousPosition.y - originalPosition.y) > 50)  {
      newPosition = originalPosition;
    }
    triangle.setPosition(newPosition);
  }

  Leaf(Vector2f position, int size) {
    triangle = CircleShape(size, 3);
    triangle.setPosition(position);
    originalPosition = position;
    auto r = (rand() % 59);
    auto g = 100 + randMaybeNeg(15);
    auto b = (rand() % 11);
    auto a = 150 + randMaybeNeg(100);

    triangle.setFillColor(Color(r, g, b, 255));
  }
};


class Branch {

public:
  RectangleShape rect;
  Vector2f base;
  vector < Branch > branches;
  vector < Leaf > leaves;
  bool hasChildren = false;
  bool isParent;

  void drawBranches(RenderWindow& window) {
    window.draw(rect);
  }

  void drawLeaves(RenderWindow& window) {
    if (!isParent) {
      for (auto i = 0; i < leaves.size(); i++) {
        leaves[i].draw(window);
      }
    }
  }

  void draw(RenderWindow& window) {
    drawLeaves(window);
    if (hasChildren) {
      for (auto i = 0; i < branches.size(); i++) {
        branches[i].draw(window);
      }
    }
    drawBranches(window);
  }

  ~Branch() {
  }

  Branch(Vector2f base, float angle, float width, float length, int generations, bool isParent)
    : isParent(isParent) {
    rect = RectangleShape(Vector2f(width, length));
    rect.setOrigin(width/2, 0);
    rect.setPosition(base);
    rect.setRotation(angle);
    rect.setFillColor(Color(83, 49, 24));

    auto newX = sin(angle * 3.14159 / 180) * length;
    auto newY = cos(angle * 3.14159 / 180) * length;
    auto tip = Vector2f(base.x - newX, base.y + newY);

    for ( int i = 0; i < NUM_LEAVES; i++) {
      auto newX = sin(angle * 3.14159 / 180) * (length * i) / NUM_LEAVES;
      auto newY = cos(angle * 3.14159 / 180) * (length * i) / NUM_LEAVES;
      auto leafPosition = Vector2f(base.x - newX, base.y + newY) + Vector2f(randMaybeNeg(25), randMaybeNeg(25));
      auto leaf = Leaf(leafPosition, LEAF_SIZE);
      leaves.push_back(leaf);
    }

    if (generations > 0) {
      float angle = rect.getRotation();
      for (int i = 0; i < generations; i++) {
        auto angleDx = randMaybeNeg(60);
        auto newAngle = angle + angleDx;
        auto newWidth = width * WIDTH_FRACTION;
        auto newLength = length * LENGTH_FRACTION;
        auto childBranch = Branch(tip, newAngle, newWidth, newLength, generations - 1);
        branches.push_back(childBranch);
      }
      hasChildren = true;
    }
  }

  Branch(Vector2f base, float angle, float width, float length, int generations)
    : Branch(base, angle, width, length, generations, false) {
  }
};

vector < Branch > genTrees() {
  vector < Branch > trees;
  for (int i = 0; i < NUMBER_OF_TREES; i ++) {
    auto x = WINDOW_WIDTH / NUMBER_OF_TREES * i + (WINDOW_WIDTH / NUMBER_OF_TREES) / 2;
    auto y = WINDOW_HEIGHT / 2;
    auto branch_length = (rand() % 100) + 80;
    Branch tree(Vector2f(x, y), INITIAL_ANGLE, BRANCH_WIDTH, branch_length, NUMBER_OF_GENERATIONS, true);
    trees.push_back(tree);
  }
  return trees;
}

int main(int, char const**) {


  srand(time(0));

  RenderWindow window(VideoMode(WINDOW_WIDTH, WINDOW_HEIGHT), "SFML window");

  vector < Branch > trees = genTrees();

  while (window.isOpen()) {
    // Process events
    sf::Event event;
    while (window.pollEvent(event)) {
      // Close window: exit
      if (event.type == sf::Event::Closed) {
        window.close();
      }

      // Escape pressed: exit
      if (event.type == sf::Event::KeyPressed
          && event.key.code == sf::Keyboard::Escape) {
        window.close();
      }

      // Escape pressed: exit
      if (event.type == sf::Event::KeyPressed
          && event.key.code == sf::Keyboard::Return) {
        trees = genTrees();
      }
    }

    // Clear screen
    window.clear();

    for (auto i = 0; i < trees.size(); i++) {
      trees[i].draw(window);
    }

    // Update the window
    window.display();
  }

  return EXIT_SUCCESS;
}
