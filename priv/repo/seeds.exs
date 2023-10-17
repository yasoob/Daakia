# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Daakia.Repo.insert!(%Daakia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Daakia.Accounts
alias Daakia.Accounts.User
alias Daakia.Newsletters
alias Daakia.Newsletters.Campaign
alias Daakia.Newsletters.Subscriber
alias Daakia.Newsletters.List
alias Daakia.Newsletters.SubscriberList

import Ash.Query
import Ash.Seed
import Ash.Changeset

user =
  User
  |> Ash.Changeset.for_create(:register_with_password, %{
    email: "hi@yasoob.me",
    password: "yasoobkhalid"
  })
  |> Daakia.Accounts.create!()

user = Daakia.Accounts.get!(User, %{email: "hi@yasoob.me"})

# Generate 100 random campaigns

Ash.set_actor(user)

for _ <- 0..100 do
  Campaign
  |> Ash.Changeset.for_create(:new_campaign, %{
    body: Enum.join(Faker.Lorem.paragraphs(2..3), "\n"),
    from_email: "hi@yasoob.me",
    subject: Faker.StarWars.quote(),
    name: "Yasoob Khalid",
    user: user
  })
  |> Newsletters.create!()
end

# Generate 100 subscribers

list =
  List
  |> Ash.Changeset.for_create(:create_new_list, %{
    name: "Main List",
    description: "Sample Description",
    type: :public,
    optin: :single
  })
  |> Newsletters.create!()

[list] = Daakia.Newsletters.List.read!()

# Create 10,000 subscribers in a naive way

for _ <- 0..10000 do
  Subscriber
  |> Ash.Changeset.for_create(:new_subscriber, %{
    email: Faker.Internet.email(),
    name: Faker.Person.name(),
    list_id: list.id
  })
  |> Newsletters.create!()
end

# Create 10,000 subscribers in a bulk way

sub_adder = fn ->
  subs =
    Enum.map(
      0..100_000,
      fn _ ->
        %{
          email: Faker.Internet.email(),
          name: Faker.Person.name(),
          list_id: list.id
        }
      end
    )

  Newsletters.bulk_create(
    subs,
    Subscriber,
    :new_subscriber,
    batch_size: 5000
  )
end

# Create 100_000 subscribers in a stream

sub_adder = fn ->
  Stream.map(0..100_000, fn _ ->
    %{
      email: Faker.Internet.email(),
      name: Faker.Person.name(),
      list_id: list.id
    }
  end)
  |> Newsletters.bulk_create(
    Subscriber,
    :new_subscriber,
    return_stream?: true,
    return_records?: true,
    batch_size: 1000
  )
  |> Stream.map(fn
    {:ok, result} ->
      result

    {:error, error} ->
      IO.puts(error)
      # process errors
  end)
  |> Enum.to_list()
end

{time, result} = :timer.tc(sub_adder, [])

sub_adder = fn ->
  Stream.map(0..100_000, fn _ ->
    %{
      email: Faker.Internet.email(),
      name: Faker.Person.name(),
      list_id: list.id
    }
  end)
  |> Newsletters.bulk_create(
    Subscriber,
    :new_subscriber,
    return_stream?: true,
    batch_size: 1000
  )
  |> Enum.to_list()
end

# Naieve approach again

subs =
  Enum.map(0..100_000, fn _ ->
    %{
      email: Faker.Internet.email(),
      name: Faker.Person.name(),
      list_id: list.id
    }
  end)

sub_adder = fn ->
  Newsletters.bulk_create(
    subs,
    Subscriber,
    :new_subscriber,
    return_records?: false,
    batch_size: 5000,
    max_concurrency: 2
  )
end

{time, result} = :timer.tc(sub_adder, [])

# Create new subscribers asynchronously

subs =
  Task.async_stream(0..500_000, fn _i ->
    %{
      email: Faker.Internet.email(),
      name: Faker.Person.name(),
      list_id: list.id
    }
  end)
  |> Enum.reduce([], fn {:ok, result}, acc -> [result | acc] end)

sub_adder = fn ->
  Newsletters.bulk_create(
    subs,
    Subscriber,
    :new_subscriber,
    return_records?: false,
    batch_size: 5000,
    max_concurrency: 9,
    upsert?: true,
    upsert_fields: [:email],
    upsert_identity: :unique_email,
    timeout: :infinity
  )
end

{time, result} = :timer.tc(sub_adder, [])

# Insert subscribers to the DB

sub_adder = fn ->
  subs
  |> Stream.chunk_every(5000)
  |> Task.async_stream(
    fn batch ->
      Newsletters.bulk_create!(
        batch,
        Subscriber,
        :new_subscriber,
        return_records?: false,
        batch_size: 1000
      )
    end,
    max_concurrency: 2
  )
  |> Stream.run()
end

{time, result} = :timer.tc(sub_adder, [])
