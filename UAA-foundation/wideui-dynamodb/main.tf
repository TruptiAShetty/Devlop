resource "aws_dynamodb_table" "dynamodb" {
  name           = "GroupAccess"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "Config-Group"
##attribute {
  ## name = "Config-Group"
   ##type = "S"
 ## }
dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}

##resource "aws_dynamodb_table_item" "example" {
##  table_name = aws_dynamodb_table.dynamodb.name
  ##hash_key   = aws_dynamodb_table.dynamodb.hash_key


  ##item = <<ITEM
##{
  ##"Config-Group": {"S": "WinGD-Service"}
##}
##ITEM

##}
