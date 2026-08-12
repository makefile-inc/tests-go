//go:build dynamic

// Copyright 2026
// license that can be found in the LICENSE file.

package main

import (
	"fmt"
	"os/user"
)

func getUser() string {
	u, err := user.Current()
	if err != nil {
		return fmt.Sprintf("ERROR: %s", err.Error())
	}
	return u.Username
}