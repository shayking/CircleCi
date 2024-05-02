package test

import (
    "os/exec"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformValidation(t *testing.T) {
    terraformOptions := &terraform.Options{
        // Path to the Terraform code directory
        TerraformDir: "..",
    }

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
