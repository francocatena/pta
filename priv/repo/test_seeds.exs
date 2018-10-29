# Reset
account = Pta.Repo.get_by(Pta.Accounts.Account, db_prefix: "test_account")

if account, do: {:ok, _} = Pta.Accounts.delete_account(account)

# Create

{:ok, _} =
  Pta.Accounts.create_account(%{
    name: "Test account",
    db_prefix: "test_account"
  })
