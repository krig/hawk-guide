name "base"
description "Base role"

run_list(
  "recipe[hawk::alice]"
)

default_attributes({

})

override_attributes({

})
