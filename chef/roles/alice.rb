name "base"
description "Base role"

run_list(
  "recipe[build]",
  "recipe[hawk::alice]"
)

default_attributes({

})

override_attributes({

})
