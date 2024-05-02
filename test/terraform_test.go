package test

import (
	"fmt"
	"os/exec"
	"testing"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	t.Run("Init", func(t *testing.T) {
		out, err := exec.Command("terraform", "init").CombinedOutput()
		if err != nil {
			t.Errorf("Error running terraform init: %v\nOutput:\n%s", err, string(out))
		}
	})

	t.Run("Validate", func(t *testing.T) {
		out, err := exec.Command("terraform", "validate").CombinedOutput()
		if err != nil {
			t.Errorf("Error running terraform validate: %v\nOutput:\n%s", err, string(out))
		}
	})

	t.Run("Plan", func(t *testing.T) {
		out, err := exec.Command("terraform", "plan").CombinedOutput()
		if err != nil {
			t.Errorf("Error running terraform plan: %v\nOutput:\n%s", err, string(out))
		}
	})

}
