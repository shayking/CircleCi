package test

import (
	"os/exec"
	"testing"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	cmd := exec.Command("terraform", "init")
	cmd.Dir = ".." // Assuming the test directory is one level inside the Terraform directory
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Errorf("Error running terraform init: %v\nOutput:\n%s", err, string(out))
	}

	cmd = exec.Command("terraform", "validate")
	cmd.Dir = ".."
	out, err = cmd.CombinedOutput()
	if err != nil {
		t.Errorf("Error running terraform validate: %v\nOutput:\n%s", err, string(out))
	}

	cmd = exec.Command("terraform", "plan")
	cmd.Dir = ".."
	out, err = cmd.CombinedOutput()
	if err != nil {
		t.Errorf("Error running terraform plan: %v\nOutput:\n%s", err, string(out))
	}
}
