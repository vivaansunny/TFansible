terraform {
  backend "azurerm" {
    storage_account_name = "terraform276"
    container_name       = "foo"
    key                  = "terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "4iG1kmacJwGlu1Pi2W2JEx7XQ46tc8KBtfawgzc+ki8usEVyHRlMnxwdFH0Mifg9l7Ulb6cBXnIw7p5Z3gu/IA=="
  }
}