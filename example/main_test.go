package main

import (
	"os"
	"testing"
)

func TestOK(t *testing.T) {
	t.Run("Ok test first", func(t *testing.T) {
		t.Log("First")
	})

	t.Run("Ok test second example", func(t *testing.T) {
		t.Log("Second")
	})
}

func TestFailExample(t *testing.T) {
	if _, ok := os.LookupEnv("DO_FAIL_TEST"); ! ok {
		t.Skip("TestFailExample skipped!")
	}
	t.Run("Fail test example", func(t *testing.T) {
		t.Log("Fail example")
		t.FailNow()
	})
}
