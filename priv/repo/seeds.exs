alias ArvoreTechChallenge.{Entity, Repo}

school_one =
  %Entity{
    name: "School Example 1",
    entity_type: :school,
    inep: "123213",
    parent_id: nil
  }
  |> Repo.insert!()

network =
  %Entity{
    name: "Network Example",
    entity_type: :network,
    inep: nil,
    parent_id: nil
  }
  |> Repo.insert!()

school_two =
  %Entity{
    name: "School Example 2",
    entity_type: :school,
    inep: "123456",
    parent_id: network.id
  }
  |> Repo.insert!()

_class_one =
  %Entity{
    name: "Class Example 1",
    entity_type: :class,
    inep: nil,
    parent_id: school_one.id
  }
  |> Repo.insert!()

_class_two =
  %Entity{
    name: "Class Example 2",
    entity_type: :class,
    inep: nil,
    parent_id: school_two.id
  }
  |> Repo.insert!()
