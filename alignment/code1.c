#include <stdio.h>

struct foo1 {
    char *p;
    char c;
    long x;
};

struct foo2 {
    char c;
    char *p;
    long x;
};

struct foo3 {
    char *p;     /* 8 bytes */
    char c;      /* 1 byte */
};

struct foo4 {
    short s;     /* 2 bytes */
    char c;      /* 1 byte */
};

int main() {
  struct foo1 f1 = { NULL, 'a', 3 };
  struct foo2 f2 = { 'a', NULL, 3 };
  struct foo3 f3 = { NULL, 'a'};
  struct foo4 f4 = { 32, 'a'};
  printf("%s", "hello world");
}
