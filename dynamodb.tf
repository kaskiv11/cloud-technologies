module "course" {
  source       = "./modules/dynamodb"
  context      = module.base_labels.context
  name         = "course"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
}

module "authors" {
  source       = "./modules/dynamodb"
  context      = module.base_labels.context
  name         = "authors"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
}
