package main

import "testing"

func TestOKAnother(t *testing.T) {
	t.Run("Another Ok", func(t *testing.T) {
		t.Log("Another")
	})
}