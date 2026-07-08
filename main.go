package main

import (
	"fmt"

	"github.com/makefile-inc/tests-go/pkg"
)

var (
	first  = "not set"
	second = "not set"
)

func main() {
	fmt.Printf("Build with '%s'\n\n", getTagStr())
	fmt.Printf("Variables:\n  first='%s'\n  second='%s'\n\n", first, second)
	fmt.Printf("Variables form pkg:\n  PkgVar='%s'\n\n", pkg.PkgVar)
	fmt.Printf("getUser: '%s'\n", getUser())
}
