#include "test.hpp"
#include <iostream>
#include <string>

#include "class1.hpp"
#include "class2.hpp"
#include "help1.h"

int Test::print()
{
    Class1 *test1 = new Class1();
    Class2 *test2 = new Class2();
    std::cout << test1->toString() << " " << test2->toString() << std::to_string(help()) << " " << std::endl;
	
    return 0;
}