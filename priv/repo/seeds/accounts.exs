defmodule Atomic.Repo.Seeds.Accounts do
  alias Atomic.Accounts
  alias Atomic.Accounts.{Course, User}
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  def run do
    case Repo.all(User) do
      [] ->
        [
          "Chandler Bing",
          "Monica Geller",
          "Ross Geller",
          "Joey Tribbiani",
          "Rachel Green",
          "Phoebe Buffay"
        ]
        |> create_users(:admin)

        [
          "Aberforth Dumbledore",
          "Adrian Mole",
          "Albus Dumbledore",
          "Albus Sverus Potter",
          "Amycus Carrow",
          "Anne Frank",
          "Anne of Green Gables",
          "Argus Filch",
          "Asterix Obelix",
          "Calvin and Hobbes",
          "Charity Burbage",
          "Charlie Brown",
          "Corto Maltese",
          "Curious George",
          "Dudley Dursley",
          "Elphias Doge",
          "Ernie Macmillan",
          "Filius Fitwick",
          "Fleur Delacour",
          "Gabrielle Delacour",
          "George Weasley",
          "Geronimo Stilton",
          "Gilderoy Lockhart",
          "Greg Heffley",
          "Gregory Goyle",
          "Hannah Abott",
          "Harry Potter",
          "Heidi and Marco",
          "Helena Ravenclaw",
          "Hermione Ganger",
          "Horce Slughorn",
          "Huckleberry Finn",
          "Hungry Catterpilar",
          "James Potter",
          "Katie Bell",
          "King Babar",
          "Lilly Evans Potter",
          "Lily Luna Potter",
          "Little Prince",
          "Lucious Malfoy",
          "Lucky Luck",
          "Luna Lovegood",
          "Mafalda Quino",
          "Malala Malala",
          "Marry Cattermole",
          "Michael Corner",
          "Molly Weasley",
          "Nancy Drew",
          "Narcissa Malfoy",
          "Neville Longbottom",
          "Nymphadora Tonks",
          "Padington Bear",
          "Padma Patil",
          "Pansy Parkinson",
          "Peppa Pig",
          "Percy Weasley",
          "Peter Rabbit",
          "Petunia Evans Dursley",
          "Pippi Longstocking",
          "Pomona Sprout",
          "Reginald Cattermole",
          "Reginald Coner",
          "Remus Lupin",
          "Rita Skeeter",
          "Rubeus Hagrid",
          "Rufus Scrimgeour",
          "Rupert Bear",
          "Scooby Doo",
          "Serlock Holmes",
          "Snoopy Dog",
          "Stuart Little",
          "Ted Tonks",
          "Throwfinn Rowle",
          "Tintin Herge",
          "Tom Sawyer",
          "Vernon Dursley",
          "Viktor Krum",
          "Vincent Crabbe",
          "Winnie de Pooh"
        ]
        |> create_users(:student)

      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  def create_users(characters, role) do
    courses = Repo.all(Course)
    organizations = Repo.all(Organization)

    for character <- characters do
      email = (character |> String.downcase() |> String.replace(~r/\s*/, "")) <> "@mail.pt"
      slug = character |> String.downcase() |> String.replace(~r/\s/, "_")

      user = %{
        "name" => character,
        "email" => email,
        "slug" => slug,
        "password" => "password1234",
        "role" => role,
        "course_id" => Enum.random(courses).id,
        "default_organization_id" => Enum.random(organizations).id,
        "confirmed_at" => DateTime.utc_now()
      }

      case Accounts.register_user(user) do
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))

        {:ok, changeset} ->
          Repo.update!(Accounts.User.confirm_changeset(changeset))
      end
    end
  end
end

Atomic.Repo.Seeds.Accounts.run()
