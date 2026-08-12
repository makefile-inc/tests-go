// Copyright 2026
// license that can be found in the LICENSE file.

package main

import (
	"os"
	"testing"
)

func TestOK(t *testing.T) {
	t.Run("Ok test first", func(t *testing.T) {
		t.Log("First")
	})

	t.Run("Ok test second", func(t *testing.T) {
		t.Log("Second")
	})
}

func TestFailFirst(t *testing.T) {
	if _, ok := os.LookupEnv("DO_FAIL_TEST"); ! ok {
		t.Skip("TestFailFirst skipped!")
	}
	t.Run("Fail test first", func(t *testing.T) {
		t.Log("Fail First")
		t.FailNow()
	})
}

func TestEnvPassed(t *testing.T) {
	t.Run("BLAH_ENV", func(t *testing.T) {
		t.Logf("BLAH_ENV=%s", os.Getenv("BLAH_ENV"))
	})
}
