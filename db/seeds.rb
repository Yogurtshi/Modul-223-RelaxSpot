# Seed users for local development and demonstrations.
# These passwords are intentionally documented for the seeded development accounts.
seed_users = [
  # Password: relaxspot-admin-2026
  {
    name: "RelaxSpot Admin",
    email: "admin@relaxspot.local",
    password: "relaxspot-admin-2026",
    role: :admin
  },
  # Password: relaxspot-moderator-2026
  {
    name: "RelaxSpot Moderator",
    email: "moderator@relaxspot.local",
    password: "relaxspot-moderator-2026",
    role: :moderator
  },
  # Password: relaxspot-user-one-2026
  {
    name: "RelaxSpot User One",
    email: "user.one@relaxspot.local",
    password: "relaxspot-user-one-2026",
    role: :user
  },
  # Password: relaxspot-user-two-2026
  {
    name: "RelaxSpot User Two",
    email: "user.two@relaxspot.local",
    password: "relaxspot-user-two-2026",
    role: :user
  }
]

seed_users.each do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])
  user.assign_attributes(attributes)
  user.save!
end

# relaxspot-user-three-2026
# relaxspot-user-three-test-2026
