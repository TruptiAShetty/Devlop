variable "attributes" {
  default = [
    {
      name = "API_access",
      type = "S",
    },
    {
      name = "test_access",
      type = "S",
    },
  ]
  type = list(object({ name = string, type = string }))
}


