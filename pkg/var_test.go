package pkg

import (
	"os"
	"testing"
)

func TestFailSecond(t *testing.T) {
	if _, ok := os.LookupEnv("DO_FAIL_TEST"); !ok {
		t.Skip("TestFailSecond skipped!")
	}
	t.Run("Fail test first", func(t *testing.T) {
		t.Log("Fail First")
		t.FailNow()
	})
}

func TestOKPkg(t *testing.T) {
	t.Run("Ok test pkg", func(t *testing.T) {
		t.Log("OK pkg")
	})
}