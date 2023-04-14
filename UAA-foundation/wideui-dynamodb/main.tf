resource "aws_dynamodb_table" "dynamodb" {
  name           = "GroupAccess"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "Config-Group"


  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.dynamodb.name
  hash_key   = aws_dynamodb_table.dynamodb.hash_key

  item = <<ITEM
{
  "Config-Group": {"S": "WinGD-Admin"},
  "Api_Access": {"S": "*"},
  "favorite": {"S": "*"},
  "Http_Verbs": {"S": "*"},
  "imo": {"S": "*"},
  "owners": {"S": "*"},
  "role": {"S": "1"}


}
ITEM
}

resource "aws_dynamodb_table_item" "example1" {
  table_name = aws_dynamodb_table.dynamodb.name
  hash_key   = aws_dynamodb_table.dynamodb.hash_key

  item = <<ITEM
{
  "Config-Group": {"S": "WinGD-Guest"},
  "Api_Access": {"L": [ {"S": "/api/v2.1/favourite"},{"S": "/api/v2.1/anglegraph"},{"S":"/api/v2.1/anglegraphsignals"},{"S": "/api/v2.1/signals"}]},
  "favorite":  {"L": [ {"S": "GET"}]},
  "Http_Verbs":  {"L": [ {"S": "GET"},{"S": "POST"}]},
  "imo": {"L": [ {"S": "9999914"}]},
  "owners":  {"L": [ {"S": "10"}]},
  "role": {"S": "3"}



}
ITEM
}

resource "aws_dynamodb_table_item" "example2" {
  table_name = aws_dynamodb_table.dynamodb.name
  hash_key   = aws_dynamodb_table.dynamodb.hash_key

  item = <<ITEM
{
  "Config-Group": {"S": "WinGD-ServiceEngineer"},
  "Api_Access": {"L": [ {"S": "/api/v2.1/favourite"},{"S": "/api/v2.1/anglegraph"},{"S":"/api/v2.1/anglegraphsignals"},{"S": "/api/v2.1/signals"}]},
  "favorite":  {"L": [ {"S": "GET"},{"S": "POST"}]},
  "Http_Verbs":  {"L": [ {"S": "GET"},{"S": "POST"},{"S": "PUT"}]},
  "imo": {"L": [ {"S": "8269773"},{"S": "8269772"},{"S": "1819839"}]},
  "owners":  {"L": [ {"S": "29"},{"S": "29"}]},
  "role": {"S": "2"}


}
ITEM
}


