//go:build test_tag_first && test_tag_second

package main

import "testing"

func TestTestTags(t *testing.T) {
	t.Run("Tags set", func(t *testing.T) {
		t.Log("Tags test_tag_first and test_tag_second were set")
	})
}