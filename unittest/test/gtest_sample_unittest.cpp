#include <gtest/gtest.h>

#include "class1.hpp"

TEST(Class1Test, Class1Test1) {
    Class1 *class1 = new Class1();

    EXPECT_EQ(class1->toString(), "Hello");
}