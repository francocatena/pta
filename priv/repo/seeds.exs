# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pta.Repo.insert!(%Pta.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, account} =
  Pta.Accounts.create_account(%{
    name: "Default",
    db_prefix: "default"
  })

session = %Pta.Accounts.Session{account: account}

{:ok, _} =
  Pta.Accounts.create_user(session, %{
    name: "Admin",
    lastname: "Admin",
    email: "admin@pta.com",
    password: "123456"
  })
