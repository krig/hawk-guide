name "base"
description "Base role"

run_list(
  "recipe[hawk::bob]"
)

default_attributes({

})

override_attributes({

})
